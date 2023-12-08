//
//  ExploreDetailViewController.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 22/11/2023.
//



import UIKit
import SafariServices
class DataManager: Codable {
    static let shared = DataManager()

    var bookmarkedTitles: [String] = [] {
        didSet {
            saveData()
        }
    }
    var selectedBook: BookViewModel?

    private let dataKey = "DataManager"

    private init() {
        loadData()
    }

    func toggleBookmark(title: String) {
        if bookmarkedTitles.contains(title) {
            bookmarkedTitles.removeAll { $0 == title }
        } else {
            bookmarkedTitles.append(title)
        }
    }
    func setSelectedBook(_ book: BookViewModel?) {
            selectedBook = book
            saveData() // Save data when selected book is set
        }

    public func saveData() {
        let defaults = UserDefaults.standard
        let encodedData = try? JSONEncoder().encode(self)
        defaults.set(encodedData, forKey: dataKey)
    }
    
    func loadFromDefaults() {
           let defaults = UserDefaults.standard
           if let savedData = defaults.data(forKey: dataKey),
              let loadedData = try? JSONDecoder().decode(DataManager.self, from: savedData) {
               // Copy the loaded data to the current instance
               self.bookmarkedTitles = loadedData.bookmarkedTitles
               self.selectedBook = loadedData.selectedBook
           }
       }

    public func loadData() {
        let defaults = UserDefaults.standard
        if let savedData = defaults.data(forKey: dataKey),
           let loadedData = try? JSONDecoder().decode(DataManager.self, from: savedData) {
            // Copy the loaded data to the current instance
            self.bookmarkedTitles = loadedData.bookmarkedTitles
            self.selectedBook = loadedData.selectedBook
        }
    }

    // Manual encoding to encode BookViewModel
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(bookmarkedTitles, forKey: .bookmarkedTitles)
        try container.encode(selectedBook, forKey: .selectedBook)
    }

    // Manual decoding to decode BookViewModel
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bookmarkedTitles = try container.decode([String].self, forKey: .bookmarkedTitles)
        selectedBook = try container.decode(BookViewModel.self, forKey: .selectedBook)
    }

    private enum CodingKeys: String, CodingKey {
        case bookmarkedTitles
        case selectedBook
    }
}


    




class ExploreDetailViewController: UIViewController {
    
    
    
    
    
    private let scrollView = UIScrollView()
    private var lastContentOffset: CGFloat = 0
    private func setupBookmarkButton() {
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    var selectedBook: BookViewModel?
    var search: [BookViewModel] = []
    var selectedBooks: [BookViewModel] = []
    

   
    // Inside your ExploreDetailViewController
    private func setupCustomTitleView() {
        let customTitleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = selectedBook?.title
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleTapped))
        customTitleView.addGestureRecognizer(tapGesture)
        
        customTitleView.addSubview(titleLabel)
        
        // Add constraints for titleLabel inside customTitleView as needed
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customTitleView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: customTitleView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: customTitleView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: customTitleView.bottomAnchor)
        ])
        
        // Set the custom view as the titleView
        navigationItem.titleView = customTitleView
    }
    
    // Inside your ExploreDetailViewController
    private func setupReadButton() {
        let readButton = UIButton(type: .system)
        readButton.setTitle("Read Book", for: .normal)
        readButton.setTitleColor(.white, for: .normal)
        readButton.tintColor = .white

        readButton.addTarget(self, action: #selector(readButtonTapped), for: .touchUpInside)

        // Add button to the view
        view.addSubview(readButton)
        readButton.alpha = 1.0
        readButton.layer.cornerRadius = 8
        readButton.backgroundColor = .systemBrown
        readButton.titleLabel?.textColor = .white

        // Add constraints for the button as needed
        readButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            readButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            readButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -38),
            readButton.widthAnchor.constraint(equalToConstant: 150),
            readButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    
    @objc private func readButtonTapped() {
            guard let infoLink = selectedBook?.infoLink, let url = URL(string: infoLink) else {
                print("Invalid URL for reading the book.")
                return
            }

            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .popover
            present(safariViewController, animated: true, completion: nil)
        
        }

    
    
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.7)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
        
        
    }))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        tabBarController?.tabBar.isHidden = false
        // or adjust its appearance
        tabBarController?.tabBar.isTranslucent = false
        titleTapped()
       
        bookmarkButtonTapped()
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isDirectionalLockEnabled = true
        collectionView.alwaysBounceVertical = true
       
        
        setupReadButton()
       

        
        
        
       
        fetchData()
        setupCustomTitleView()
        
        view.addSubview(collectionView)
        collectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            
        ])
        
        
        
        view.backgroundColor = .systemBackground
        setupBookmarkButton()
        updateBookmarkButtonAppearance()
        
        
    }
    
   

    @objc private func titleTapped() {
        guard let selectedTitle = selectedBook?.title else {
            return
        }

        // Add or remove the title from the bookmarkedTitles array based on its current state
        if DataManager.shared.bookmarkedTitles.contains(selectedTitle) {
            DataManager.shared.bookmarkedTitles.removeAll { $0 == selectedTitle }
        } else {
            DataManager.shared.bookmarkedTitles.append(selectedTitle)
            print(DataManager.shared.bookmarkedTitles)
        }

        // Set the selectedBook in DataManager.shared
        DataManager.shared.selectedBook = selectedBook

        // Update the bookmark button appearance
        updateBookmarkButtonAppearance()
    }

    
    
    
    private func updateBookmarkButtonAppearance() {
        let isBookmarked = selectedBook?.isBookmarked ?? false

        // Update bookmark button
        let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        navigationItem.rightBarButtonItem = bookmarkButton

        // Update label text based on bookmark status
        if let bookmarkStatusLabel = navigationItem.titleView?.viewWithTag(123456) as? UILabel {
            bookmarkStatusLabel.text = isBookmarked ? "Bookmarked" : "Not Bookmarked"
        } else {
            let bookmarkStatusLabel = UILabel()
            bookmarkStatusLabel.tag = 123 // Set a unique tag to identify the label
            bookmarkStatusLabel.text = isBookmarked ? "Bookmarked" : "Not Bookmarked"
            navigationItem.titleView?.addSubview(bookmarkStatusLabel)
            // Add constraints for bookmarkStatusLabel inside customTitleView as needed
        }
    }

    @objc private func bookmarkButtonTapped() {

        // Update the bookmark button appearance
        updateBookmarkButtonAppearance()
    }

    


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
     
        
    }
    
    private func fetchData() {
           guard let selectedQuery = selectedBook?.title else {
               return
           }

           APICallers.fetchBooks(withQuery: selectedQuery, maxResults: 3) { [weak self] result in
               switch result {
               case .success(let response):
                   if let items = response.items, let firstItem = items.first {
                       self?.search = [BookViewModel(id: firstItem.id, volumeInfo: firstItem.volumeInfo, accessInfo: firstItem.accessInfo)]
                       DispatchQueue.main.async {
                           // Set the title here
                           self?.title = self?.selectedBook?.title
                           
                           
                           self?.navigationItem.title = self?.selectedBook?.title

                           // Adjust title properties
                           

                           self?.collectionView.reloadData()
                       }
                   }
               case .failure(let error):
                   print("Error: \(error)")
               }
           }
       }
   
   

    
    
}
    

   


extension ExploreDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.identifier, for: indexPath) as? ExploreCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = search[indexPath.row]
        cell.configure(viewModel: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           // Adjust the size of your collection view cells as needed
           return CGSize(width: collectionView.bounds.width, height: 100)
       }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          guard let collectionView = scrollView as? UICollectionView else {
              return
          }

          let currentOffset = collectionView.contentOffset.y
          let collectionViewHeight = collectionView.bounds.height > 0 ? collectionView.bounds.height : 1

          // Check if the scrolling direction is upward (contentOffset.y is decreasing)
          if currentOffset < lastContentOffset && collectionViewHeight > 0 {
              // Allow the user to freely move the content upward
              let newY = max(0, currentOffset)
              collectionView.setContentOffset(CGPoint(x: 0, y: newY), animated: false)
          }

          lastContentOffset = currentOffset
      }
    
    
    
}
