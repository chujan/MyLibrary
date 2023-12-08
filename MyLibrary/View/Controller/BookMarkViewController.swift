//
//  BookMarkViewController.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 29/11/2023.
//




import UIKit
import SafariServices

class BookMarkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    var selectedBook: BookViewModel?
    var search: [BookViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad - Initial Title: \(title ?? "nil")")
        title = "Bookmark"
        
        // ... rest of your code
        DataManager.shared.loadData()
        DataManager.shared.saveData()
      


        let selectedBook = DataManager.shared.selectedBook
        


        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.addSubview(tableView)
        
        // Fetch initial data
        didUpdateBookmarks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didUpdateBookmarks()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.bookmarkedTitles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
       
        

        // ...

        let bookmarkedTitle = DataManager.shared.bookmarkedTitles[indexPath.row]

        // Set up textLabel
        cell.textLabel?.text = "\(bookmarkedTitle)"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false

        // Check if bookmarkImageView is already added
        if cell.contentView.viewWithTag(123) == nil {
            // Set up bookmarkImageView
            let bookmarkImageView = UIImageView(image: UIImage(systemName: "bookmark.fill"))
            bookmarkImageView.tag = 123 // Set a unique tag to identify it
            bookmarkImageView.tintColor = .systemBlue // Set the color as needed
            bookmarkImageView.contentMode = .scaleAspectFit
            bookmarkImageView.translatesAutoresizingMaskIntoConstraints = false

            // Create a horizontal stack view
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.translatesAutoresizingMaskIntoConstraints = false

            // Add textLabel and bookmarkImageView to the stack view
            
            stackView.addArrangedSubview(bookmarkImageView)

            // Add stackView to the contentView
            cell.contentView.addSubview(stackView)

            // Set up constraints for the stack view
            NSLayoutConstraint.activate([
                stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor,constant: -50),
                stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: +380),
                stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                cell.textLabel!.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -50),
                cell.textLabel!.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                cell.textLabel!.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: +140),
                                
            ])
        }
        let deleteButton = UIButton(type: .system)
          deleteButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
          deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
          deleteButton.tag = indexPath.row // Set a tag to identify the button

          // Check if deleteButton is already added
          if cell.contentView.viewWithTag(456) == nil {
              // Set up constraints for the delete button
              deleteButton.translatesAutoresizingMaskIntoConstraints = false
              cell.contentView.addSubview(deleteButton)
              NSLayoutConstraint.activate([
                  deleteButton.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor, constant: -10),
                  deleteButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -20),
                  deleteButton.widthAnchor.constraint(equalToConstant: 30),
                  deleteButton.heightAnchor.constraint(equalToConstant: 100),
              ])
          }


        if indexPath.row < search.count {
            let viewModel = search[indexPath.row]
            cell.configure(viewModel: viewModel)
        }

        return cell
    }
    // Handle delete button tap
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag

        // Verify that the index is valid
        guard index < DataManager.shared.bookmarkedTitles.count else {
            return
        }

        let bookTitle = DataManager.shared.bookmarkedTitles[index]

        // Create an alert controller
        let alertController = UIAlertController(title: "Delete Bookmark", message: "Are you sure you want to delete \(bookTitle)?", preferredStyle: .alert)

        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Add a delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            // Perform delete operation based on the index
            DataManager.shared.bookmarkedTitles.remove(at: index)

            // Update the search array if needed
            if index < self?.search.count ?? 0 {
                self?.search.remove(at: index)
            }

            // Reload the table view to reflect the changes
            self?.tableView.reloadData()
        }
        alertController.addAction(deleteAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    
   



    func didUpdateBookmarks() {
        guard let selectedBook = DataManager.shared.selectedBook else {
            return
        }

        fetchData(with: selectedBook)
    }

    private func fetchData(with book: BookViewModel) {
        let selectedQuery = book.title

        print("Fetching data for book: \(selectedQuery)")

        APICallers.fetchBooks(withQuery: selectedQuery, maxResults: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let items = response.items {
                    let newSearchItems = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo) }

                    // Append the new items to the existing search array
                    self?.search += newSearchItems

                    // Print relevant information

                    DispatchQueue.main.async {
                        print("Setting title in fetchData: \(self?.selectedBook?.title ?? "nil")")
                        self?.title = self?.selectedBook?.title ?? "Bookmark"
                        self?.navigationItem.title = self?.selectedBook?.title ?? "Bookmark"
                        print("titt")

                        // Reload data after updating search array
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoLink = search[indexPath.row].infoLink
        if let url = URL(string: infoLink!) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .popover
            present(safariViewController, animated: true, completion: nil)
        } else {
            print("invalid url")
        }
    }

  
}
