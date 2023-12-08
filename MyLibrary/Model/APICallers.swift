//
//  APICallers.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 10/11/2023.
//
import Foundation
import Combine

class APICallers {
    
    enum APIError: Error {
        case invalidURL
        case noData
    }
    let apiKey = "AIzaSyCQQfhFwXskP4tQrt81IufFrh3JZCssCXc"
    static let shared = APICallers()
    private init() {}
    
    static func fetchBooksPublisher(withQuery query: String, maxResults: Int = 20) -> AnyPublisher<GoogleBooksAPIResponse, Error> {
        let apiKey = "AIzaSyCQQfhFwXskP4tQrt81IufFrh3JZCssCXc"
        let baseURL = "https://www.googleapis.com/books/v1/volumes"
        let queryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=\(queryString)&maxResults=\(maxResults)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail<GoogleBooksAPIResponse, Error>(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GoogleBooksAPIResponse.self, decoder: JSONDecoder())
            .mapError { error in
                APIError.noData
            }
            .eraseToAnyPublisher()
    }
    
    
    static func fetchBooks(withQuery query: String, maxResults: Int = 30, completion: @escaping (Result<GoogleBooksAPIResponse, Error>) -> Void) {
        let apiKey = "AIzaSyCQQfhFwXskP4tQrt81IufFrh3JZCssCXc"
        let baseURL = "https://www.googleapis.com/books/v1/volumes"
        let queryString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=\(queryString)&maxResults=\(maxResults)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GoogleBooksAPIResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func fetchBooksFromBookshelf(bookshelfId: String, accessToken: String) {
        let booksURL = "https://www.googleapis.com/books/v1/mylibrary/bookshelves/\(bookshelfId)/volumes"
        
        if let url = URL(string: booksURL) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error fetching books: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let errorInfo = json?["error"] as? [String: Any] {
                        // Handle specific error information
                        print("Error fetching books: \(errorInfo)")
                    } else {
                        let totalItems = json?["totalItems"] as? Int ?? 0
                        
                        if totalItems == 0 {
                            print("No books found in the bookshelf.")
                        } else {
                            // Process the books data as needed
                            // You can update your UI or perform other actions here
                            print("Books response: \(json ?? [:])")
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            task.resume()
        }
    }
    static func addBookToBookshelf(bookshelfId: String, id: String, accessToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let addBookURL = "https://www.googleapis.com/books/v1/mylibrary/bookshelves/\(bookshelfId)/addVolume?volumeId=\(id)"
        
        guard let url = URL(string: addBookURL) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    // Treat both 200 and 204 as success
                    print("Book added to the bookshelf successfully!")
                    completion(.success(()))
                } else {
                    // Print the response content for further investigation
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response content: \(responseString)")
                    }
                    print("Failed to add the book. Check the response for more details.")
                    
                    // Provide a more detailed error message
                    completion(.failure(NSError(domain: "Failed to add book", code: httpResponse.statusCode, userInfo: nil)))
                }
            }
        }
        
        task.resume()
    }


}

