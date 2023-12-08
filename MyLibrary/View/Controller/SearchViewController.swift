//
//  SearchViewController.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 16/11/2023.
//

import UIKit
import Combine
import GoogleSignIn
class BookManager {
    static let shared = BookManager()

    var addedBooks: [BookViewModel] = []
    var bookAddedCallback: (([BookViewModel]) -> Void)?

    private init() {}

    func addBook(_ book: BookViewModel) {
        addedBooks.append(book)
        bookAddedCallback?(addedBooks)

        // Post a notification when a book is added
        NotificationCenter.default.post(name: .bookAddedNotification, object: book)
    }
}

extension Notification.Name {
    static let bookAddedNotification = Notification.Name("BookAddedNotification")
}





class SearchViewController: UIViewController {
    var addedBooks: [BookViewModel] = []
    
    
   

    let bookshelfId = "0"
   
        // Other properties...

        var selectedGenreIndexBackup: Int?

        // Rest of your class code...
    

    private let genreFilter: UISegmentedControl = {
            let segmentedControl = UISegmentedControl(items: ["fiction", "Mystery", "Science Fiction", "Romance"])
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            return segmentedControl
        }()

 
    

    let apiCallers = APICallers.shared
    private let initialDataFetchedSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    var viewModels: [BookViewModel] = []
   
   
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
        
    }()
    var searchController = UISearchController()
    var initialDataFetched = false
   
      

        var searchQuery = String() {
            didSet {
             didSetSearchQuery()
               
            }
        }
    private func didSetSearchQuery() {
            if !searchQuery.isEmpty {
                print("Fetching data for query: \(searchQuery)")
                let cancellable = APICallers.fetchBooksPublisher(withQuery: searchQuery)
                    .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                        switch completion {
                        case .failure(let error):
                            print("Error: \(error.localizedDescription)")
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] book in
                        if let items = book.items {
                            self?.viewModels = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo)}
                            DispatchQueue.main.async {
                                self?.applyFilters()
                                self?.tableView.reloadData()
                            }
                        }
                    })

                cancellable.store(in: &cancellables)
            } else {
               
                
                fetchData()
            }
        }
    private var selectedGenreIndex: Int = UISegmentedControl.noSegment {
            didSet {
                // This will be triggered whenever the selected segment changes
                applyFilters()
            }
        }


       

    
    
    
    
    private func configureSearchController() {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
           searchController.searchBar.backgroundColor = .white
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Books"
            navigationItem.searchController = searchController
        }


    override func viewDidLoad() {
        super.viewDidLoad()
       
        BookManager.shared.bookAddedCallback = { [weak self] addedBooks in
                    self?.addedBooks = addedBooks
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
                   
                }
       
        
        genreFilter.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        
       
       
       
       
        fetchData()
       
     
        // Add these lines after setting up constraints
        
       
        tableView.delegate = self
        tableView.dataSource = self
        initialDataFetchedSubject
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.applyFilters()
                }
               
               
            })
            .store(in: &cancellables)
        
        configureSearchController()
        setUpConstraint()
        view.backgroundColor = .systemBackground
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)

        
    }
    private func setUpConstraint() {
       
        view.addSubview(genreFilter)
       
        view.addSubview(tableView)  // Move tableView here

    let filterStackView = UIStackView(arrangedSubviews: [genreFilter])
        filterStackView.axis = .horizontal
        filterStackView.spacing = 10
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterStackView)
        filterStackView.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            
            filterStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: +180),
            
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
           
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])

        // Move these constraints here
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ])

       
        filterStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        filterStackView.setContentHuggingPriority(.required, for: .vertical)

        tableView.setContentCompressionResistancePriority(.required, for: .vertical)
        tableView.setContentHuggingPriority(.required, for: .vertical)
    }



    
    



    
        // ... other methods ...
    
    
    public func fetchData() {
        APICallers.fetchBooksPublisher(withQuery: "marriage")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching initial stock data: \(error.localizedDescription)")
                case .finished:
                    self.initialDataFetchedSubject.send()
                }
                
            }, receiveValue: { [weak self] book in
                if let items = book.items {
                    self?.viewModels = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo)}
                    print("Data fetched successfully: \(self?.viewModels.count ?? 0) items")
                    DispatchQueue.main.async {
                        
                        self?.tableView.reloadData()
                    }
                } else {
                    print("No items received from API")
                }
            })
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyFilters()
        tableView.reloadData()
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        print("Segmented control value changed")
           selectedGenreIndex = sender.selectedSegmentIndex
       applyFilters()
           
           // Apply filters after handling deselection
           
       }
   


       

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }

        let search = viewModels[indexPath.row]
        cell.configure(viewModel: BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo))

        // Remove existing addButton if any
      

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let selectedBook = viewModels[indexPath.row]
          let vc = ExploreDetailViewController()

          // Pass the selected book to ExploreDetailViewController
          vc.selectedBook = selectedBook

          navigationController?.pushViewController(vc, animated: true)
      }
    
          
                           
                 
   }
    
    



extension SearchViewController: UISearchResultsUpdating {
       func updateSearchResults(for searchController: UISearchController) {
           guard let searchQuery = searchController.searchBar.text,!searchQuery.isEmpty else {
               self.searchQuery = ""
               self.viewModels = []
               DispatchQueue.main.async {
                   self.applyFilters()
                   self.tableView.reloadData()
               }
               return
           }
           self.searchQuery = searchQuery
       }
   }
extension SearchViewController {
    
    // Function to set filters programmatically
    func setFilters(genre: String?, author: String?, rating: Int?) {
        // Set genre filter
        if let genre = genre {
            let index = genreFilter.numberOfSegments - 1
            for i in 0...index {
                if let title = genreFilter.titleForSegment(at: i), title == genre {
                    genreFilter.selectedSegmentIndex = i
                    break
                }
            }
        } else {
            genreFilter.selectedSegmentIndex = UISegmentedControl.noSegment
        }
        
        // Set author filter
//        if let author = author {
//            let index = authorFilter.numberOfSegments - 1
//            for i in 0...index {
//                if let title = authorFilter.titleForSegment(at: i), title == author {
//                    authorFilter.selectedSegmentIndex = i
//                    break
//                }
//            }
//        } else {
//            authorFilter.selectedSegmentIndex = UISegmentedControl.noSegment
//        }
        
        // Set rating filter
//
        
        // Apply filters
        applyFilters()
    }
    func applyFilters() {
        print("Applying filters")

        let selectedGenreIndex = genreFilter.selectedSegmentIndex

        // Check if the selected segment index is different from the previous one
        guard selectedGenreIndex != selectedGenreIndexBackup else {
            return
        }

        selectedGenreIndexBackup = selectedGenreIndex

        let selectedGenre = selectedGenreIndex != UISegmentedControl.noSegment ? genreFilter.titleForSegment(at: selectedGenreIndex)?.lowercased() : nil

        print("Selected Genre: \(selectedGenre ?? "No genre selected")")

        if let selectedGenre = selectedGenre, !selectedGenre.isEmpty, selectedGenre.lowercased() != "categories" {
            print("Fetching data for genre: \(selectedGenre)")
            
            let cancellable = APICallers.fetchBooksPublisher(withQuery: selectedGenre)
                .sink(receiveCompletion: { (completion: Subscribers.Completion<Error>) in
                    switch completion {
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] book in
                    if let items = book.items {
                        let filteredModels = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo)}
                        DispatchQueue.main.async {
                            self?.viewModels = filteredModels
                            self?.tableView.reloadData()
                        }
                    }
                })

            cancellable.store(in: &cancellables)
        } else {
            // Handle the case when no specific genre is selected (similar to your previous logic)
            let filteredModels = viewModels
            DispatchQueue.main.async {
                self.viewModels = filteredModels
                self.tableView.reloadData()
            }
        }
    }



    
  
}

