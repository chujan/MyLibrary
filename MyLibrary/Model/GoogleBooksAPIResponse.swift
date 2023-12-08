//
//  BookResponse.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 18/11/2023.
//

import Foundation



struct GoogleBooksAPIResponse: Codable {
    let items: [BookItem]?

    struct BookItem: Codable {
        let volumeInfo: VolumeInfo
        let accessInfo: AccessInfo
        let id: String
         
        
       
    }

    struct VolumeInfo: Codable {
        let title: String
        let averageRating: Double?
        let description: String?
        let ratingsCount: Int?
        let industryIdentifiers: [IndustryIdentifier]?
        let publisher: String?
        let publishedDate: String?
        let pageCount: Int?
        let authors: [String]?
        let categories: [String]?
        let imageLinks: ImageLinks?
        let infoLink: String?
        var isBookmarked: Bool?
         
    }

    struct ImageLinks: Codable {
        let smallThumbnail: String?
        let thumbnail: String?
    }
   
   

    struct AccessInfo: Codable {
        let epub: Epub
    }

    struct Epub: Codable {
        let isAvailable: Bool
    }
    
    struct IndustryIdentifier: Codable {
        let type: String
        let identifier: String
    }
}
