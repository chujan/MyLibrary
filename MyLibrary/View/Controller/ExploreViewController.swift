//
//  ExploreViewController.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 18/11/2023.
//

import UIKit
struct BookViewModel: Codable {
    let id: String
    let title: String
    let averageRating: Double?
    let authors: [String]?
    let categories: [String]?
    let infoLink: String?
    let description: String?
    let publisher: String?
    let publishedDate: String?
    let industryIdentifiers: [GoogleBooksAPIResponse.IndustryIdentifier]?
    let pageCount: Int?
    let ratingsCount: Int?
    let thumbnailURL: URL?
    let isAvailable: Bool?
    var isBookmarked: Bool?
 
    
    // Assuming you have a property 'volumeInfo' of type 'GoogleBooksAPIResponse.VolumeInfo'
    let volumeInfo: GoogleBooksAPIResponse.VolumeInfo
    
    // Assuming you have a property 'accessInfo' of type 'GoogleBooksAPIResponse.AccessInfo'
    let accessInfo: GoogleBooksAPIResponse.AccessInfo
   

    init(id: String,volumeInfo: GoogleBooksAPIResponse.VolumeInfo, accessInfo: GoogleBooksAPIResponse.AccessInfo) {
        self.id = id
        self.title = volumeInfo.title
        self.authors = volumeInfo.authors
        self.publisher = volumeInfo.publisher
        self.pageCount = volumeInfo.pageCount
        self.publishedDate = volumeInfo.publishedDate
        self.industryIdentifiers = volumeInfo.industryIdentifiers
        self.description = volumeInfo.description
        self.categories = volumeInfo.categories
        self.ratingsCount = volumeInfo.ratingsCount
        self.averageRating = volumeInfo.averageRating
        self.thumbnailURL = URL(string: volumeInfo.imageLinks?.thumbnail ?? "")
        self.isAvailable = accessInfo.epub.isAvailable // Set isAvailable based on your data
        self.volumeInfo = volumeInfo
        self.isBookmarked = volumeInfo.isBookmarked
        self.accessInfo = accessInfo
        self.infoLink = volumeInfo.infoLink
    }
}


class ExploreViewController: UIViewController {
   
    
    
    enum Sections: Int, CaseIterable {
        case BusinessEconomics = 0
        case Computers = 1
        case Google = 2
        case Education = 3
        case LanguageArtsDisciplines = 4
        case Law = 5
    }
    private var collectionview: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout:  UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return ExploreViewController.createSectionLayout(section: sectionIndex)
        
    })
    let sectionTitles: [String] = ["Category", "Recommeneded", "Popular", "Featured", "Language Arts & Disciplines", "Law"]
    var tabs: [String] = []
    private var selectionIndex = 0
    var viewModels: [BookViewModel] = []
    var gi: [BookViewModel] = []
    var computer: [BookViewModel] = []
    var google: [BookViewModel] = []
    var psychology: [BookViewModel] = []
    var language :[BookViewModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explore"
        
        view.addSubview(collectionview)
        configureCollectionViewCell()
        collectionview.dataSource = self
        collectionview.delegate = self
        addShareButton()
        
       
        fetch()
        

        
    }
    
    private func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        
    }
    @objc private func didTapSearch() {
        let vc = SearchViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    
    private func configureCollectionViewCell() {
        collectionview.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifer)
        
        collectionview.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
        
        collectionview.register(ClassicCollectionViewCell.self, forCellWithReuseIdentifier: ClassicCollectionViewCell.identifier)
        
        collectionview.register(RomanceCollectionViewCell.self, forCellWithReuseIdentifier: RomanceCollectionViewCell.identifier)
        
        
        collectionview.register(KidsCollectionViewCell.self, forCellWithReuseIdentifier: KidsCollectionViewCell.identifier)
        
        collectionview.register(ThrillersCollectionViewCell.self, forCellWithReuseIdentifier: ThrillersCollectionViewCell.identifier)
        
        collectionview.register(TextBooksCollectionViewCell.self, forCellWithReuseIdentifier: TextBooksCollectionViewCell.identifier)
        
       
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionview.frame = view.bounds
    }
    
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews

                return section
            
          
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 4:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 5 :
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        }
        
    }
    
    private func fetch()  {
       
       

        APICallers.fetchBooks(withQuery: "allcategory") { [weak self] result in
            switch result {
            case .success(let response):
                
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.gi = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo ) }
                   
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        APICallers.fetchBooks(withQuery: "Recommended", maxResults: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.computer = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo) }
                    print(BookViewModel.self)
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        APICallers.fetchBooks(withQuery: "featured", maxResults: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.viewModels = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo) }
                    print(BookViewModel.self)
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        APICallers.fetchBooks(withQuery: "popular", maxResults: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.google = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo) }
                   
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        APICallers.fetchBooks(withQuery: "Language Arts & Disciplines", maxResults: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.language = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo) }
                    print(BookViewModel.self)
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        APICallers.fetchBooks(withQuery: "Education", maxResults: 20) { [weak self] result in
            switch result {
            case .success(let response):
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.psychology = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo) }
                    print(BookViewModel.self)
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        

        
    }
    
    
   

}
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.BusinessEconomics.rawValue:
            return gi.count
        case Sections.Law.rawValue:
            return viewModels.count
        case Sections.Education.rawValue:
            return psychology.count
        case Sections.Computers.rawValue:
            return computer.count
        case Sections.LanguageArtsDisciplines.rawValue:
            return language.count
        case Sections.Google.rawValue:
            return google.count
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Sections.BusinessEconomics.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = gi[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
        case Sections.Education.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ClassicCollectionViewCell.identifier, for: indexPath) as? ClassicCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = psychology[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
        case Sections.Law.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ThrillersCollectionViewCell.identifier, for: indexPath) as? ThrillersCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = viewModels[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
        case Sections.Google.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: RomanceCollectionViewCell.identifier, for: indexPath) as? RomanceCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = google[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
        case Sections.LanguageArtsDisciplines.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: KidsCollectionViewCell.identifier, for: indexPath) as? KidsCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = language[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
        case Sections.Computers.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: TextBooksCollectionViewCell.identifier, for: indexPath) as? TextBooksCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = computer[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
            
        default:
            return UICollectionViewCell()
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionview.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifer, for: indexPath) as? TitleHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let section = indexPath.section
        let title = sectionTitles[section]
        header.configure(with: title)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ExploreDetailViewController()
       
        
        // Pass the selected data to ExploreDetailViewController if needed
        var selectedBooks: [BookViewModel] = []
        let section = indexPath.section
        
        switch section {
        case Sections.BusinessEconomics.rawValue:
            selectedBooks = [gi[indexPath.row]]
        case Sections.Education.rawValue:
            selectedBooks = [psychology[indexPath.row]]
        case Sections.Law.rawValue:
            selectedBooks = [viewModels[indexPath.row]]
        case Sections.Google.rawValue:
            selectedBooks = [google[indexPath.row]]
        case Sections.LanguageArtsDisciplines.rawValue:
            selectedBooks = [language[indexPath.row]]
        case Sections.Computers.rawValue:
            selectedBooks = [computer[indexPath.row]]
        default:
            break
        }
        
        vc.selectedBook = selectedBooks.first
        
        // Set the title of ExploreDetailViewController to the selected book title
        //        if indexPath.row < selectedBooks.count {
        //            vc.title = selectedBooks[indexPath.row].title
        //        }
        
        navigationController?.pushViewController(vc, animated: true)
        // Add this line in your ExploreDetailViewController's viewDidLoad or viewWillAppear method
        navigationItem.largeTitleDisplayMode = .never
        
        // navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .white // Example color, adjust as needed
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] // Example color, adjust as needed
        
    }
    
    
    
    
}
