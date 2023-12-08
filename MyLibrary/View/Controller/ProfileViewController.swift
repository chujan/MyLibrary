//
//  ProfileViewController.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 28/11/2023.
//

import UIKit
import SafariServices
enum Sections: Int, CaseIterable {
    case readingNow = 0
    case  recentlyRead = 1
}

class ProfileViewController: UIViewController {
    var userPreferences: UserPreferences = UserPreferences(fontType: "Default", theme: "Light", fontSize: 14.0)

    var viewModel: [BookViewModel] = []
    var gi: [BookViewModel] = []
    let authService = AuthService()
   
    
    
    // Replace the existing collection view instantiation with this code
    private var collectionview: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x: 10, y: 10, width: 200, height: 200), collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return ProfileViewController.createSectionLayout(section: sectionIndex)
        })
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let sectionTitles: [String] = ["Readingnow", "RecentlyRead"]
    private let placeholderImage = UIImage(systemName: "person")
    private var userContent: UserContent?
    
    private let nameLabel: UILabel = {
           let label = UILabel()
           label.textColor = .black
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    private let usernameLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    private let emailLabel: UILabel = {
           let label = UILabel()
           label.textColor = .black
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 16)
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()


    
    private lazy var  profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 50
        imageView.image = placeholderImage
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private let changePictureButton: UIButton = {
        let button = UIButton()
        // Use the camera system symbol for the button image
        let cameraImage = UIImage(systemName: "camera")
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let contentSummaryLabel: UILabel = {
            let label = UILabel()
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch and update user information
        updateUserInfo()
        if let savedProfileImage = loadProfileImage() {
              profileImageView.image = savedProfileImage
          }

        collectionview.delegate = self
        collectionview.dataSource = self
        view.addSubview(collectionview)
        view.addSubview(profileImageView)
        view.addSubview(changePictureButton)
        view.addSubview(nameLabel)
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
        view.addSubview(contentSummaryLabel)
        setUpCollectionViews()
      
       

        // Other setup code...

        setUpConstraints()
        fecthData()

        changePictureButton.addTarget(self, action: #selector(changeProfilePictureTapped), for: .touchUpInside)

        title = "Profile"
        userContent = UserContent(
            authors: ["Author 1", "Author 2", "Author 3"],
            audioTracks: ["Audio Track 1", "Audio Track 2", "Audio Track 3"]
        )

       // updateUIWithUserContent()
        let signOutButton = UIButton()
           signOutButton.setTitle("Sign Out", for: .normal)
           signOutButton.setTitleColor(.red, for: .normal)
           signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
           signOutButton.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(signOutButton)

           // ... (existing code)

           // Add Sign Out Button Constraints
           NSLayoutConstraint.activate([
               // ... (existing constraints)

               signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
               signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
           ])
    }
    private let signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        //collectionview.frame = view.frame
    }
    private func setUpCollectionViews() {
       
        collectionview.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: TrendingCollectionViewCell.identifier)
        collectionview.register(ClassicCollectionViewCell.self, forCellWithReuseIdentifier: ClassicCollectionViewCell.identifier)
        collectionview.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifer)
        
       
        
    }
    
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            changePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            changePictureButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: changePictureButton.bottomAnchor, constant: 8),
            
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            contentSummaryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentSummaryLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            contentSummaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentSummaryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionview.topAnchor.constraint(equalTo: contentSummaryLabel.bottomAnchor, constant: 20),
                collectionview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                //collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             collectionview.heightAnchor.constraint(equalToConstant: 600),
            
          

            
            

            
            
        ])
        
    }
    
    
    
    @objc func signOutButtonTapped() {
        // Ask the user for confirmation using an action sheet
        let actionSheet = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)

        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            // Perform sign out logic here
            self?.performSignOut()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(signOutAction)
        actionSheet.addAction(cancelAction)

        present(actionSheet, animated: true, completion: nil)
    }

    func performSignOut() {
        // Clear user information from UserDefaults
        UserDefaults.standard.removeObject(forKey: "signedInUserName")
        UserDefaults.standard.removeObject(forKey: "signedInUserUsername")
        UserDefaults.standard.removeObject(forKey: "signedInUserEmail")
        UserDefaults.standard.synchronize()

        // Navigate to the sign-in or initial screen
        navigateToSignIn()
    }


    private func navigateToSignIn() {
        let signInViewController = SignInViewController() // Instantiate your sign-in view controller
        let navigationController = UINavigationController(rootViewController: signInViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }

    
    private func updateProfileLabels() {
        if let signedInUserName = UserDefaults.standard.string(forKey: "signedInUserName"),
           let signedInUserEmail = UserDefaults.standard.string(forKey: "signedInUserEmail") {
            nameLabel.text = signedInUserName
            emailLabel.text = signedInUserEmail
        }
    }

    @objc private func changeProfilePictureTapped() {
        showImagePickerOption()
        
    }
    func  imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
    
    func showImagePickerOption() {
        let alertVC = UIAlertController(title: "Pick a Photo", message: "Choose a picture from Library or camera", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self = self else {
                return
            }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true) {
                
            }
            
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self = self else {
                return
            }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true) {
                
            }
            
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    private func fecthData() {
        APICallers.fetchBooks(withQuery: "all") { [weak self] result in
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
        APICallers.fetchBooks(withQuery: "inspiration") { [weak self] result in
            switch result {
            case .success(let response):
                
                if let items = response.items {
                    // Assuming BookViewModel is a struct or class that you create to represent the view model
                    self?.viewModel = items.map { BookViewModel(id: $0.id, volumeInfo: $0.volumeInfo, accessInfo: $0.accessInfo ) }
                   
                    DispatchQueue.main.async {
                        self?.collectionview.reloadData()
                        
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
  
   

  


    
    
    private func updateUIWithUserContent() {
        guard let userContent = userContent else { return }

        let audioTracksCount = userContent.audioTracksCount
        let ebooksCount = userContent.authorsCount

        // Adjust the text based on the count
        let audioTracksText = audioTracksCount == 1 ? "audio track" : "audio tracks"
        let ebooksText = ebooksCount == 1 ? "ebook" : "ebooks"

        // Calculate the necessary spacing for alignment
        let maxTextLength = max(audioTracksText.count, ebooksText.count)
        let spacingForAudioTracks = String(repeating: " ", count: maxTextLength + 4) // Adjusted spacing
        let spacingForEbooks = String(repeating: " ", count: maxTextLength + 4) // Adjusted spacing

        // Modify the summaryText to have counts aligned under "audio track" with consistent spacing
        let summaryText = """
        \(audioTracksText)\(spacingForAudioTracks)\(ebooksText)
        \(audioTracksCount)\(String(repeating: " ", count: maxTextLength - "\(audioTracksCount)".count + 20))\(ebooksCount)
        """
        contentSummaryLabel.text = summaryText

        // Ensure the layout is updated
        view.layoutIfNeeded()
    }
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 10)
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: item, count: 1)
            let horizontalgroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)), repeatingSubitem: verticalGroup, count: 1)
            let section = NSCollectionLayoutSection(group: horizontalgroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
//            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
//            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.7)), subitems: [item])
//            let section = NSCollectionLayoutSection(group: group)
//            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//
            
            
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(160), heightDimension: .absolute(200)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 2, trailing: 10)
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
    
    func updateUserInfo() {
        guard let signedInUsername = UserDefaults.standard.string(forKey: "signedInUserName"),
              let signedInUserUsername = UserDefaults.standard.string(forKey: "signedInUserUsername"),
              let signedInUserEmail = UserDefaults.standard.string(forKey: "signedInUserEmail") else {
            return
        }

        // Update labels with user information
        DispatchQueue.main.async {
            self.nameLabel.text = signedInUsername
            self.usernameLabel.text = signedInUserUsername
            self.emailLabel.text = signedInUserEmail
        }

        // Fetch and update additional user information if needed
        authService.fetchUser(username: signedInUsername) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    // Update UI elements with additional user information
                    // For example, update contentSummaryLabel with additional user information
                   
                }

            case .failure(let error):
                print("Error fetching user information: \(error)")
                // Handle the error (e.g., show an alert to the user)
            }
        }
    }




    



    
}



extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.readingNow.rawValue:
            return gi.count
        case Sections.recentlyRead.rawValue:
            return viewModel.count
        default:
            return 0
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Sections.readingNow.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.identifier, for: indexPath) as? TrendingCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = gi[indexPath.row]
            let bookViewModel = BookViewModel(id: search.id, volumeInfo: search.volumeInfo, accessInfo: search.accessInfo)
            cell.configure(viewModel: bookViewModel)
            
            return cell
        case Sections.recentlyRead.rawValue:
            guard let cell = collectionview.dequeueReusableCell(withReuseIdentifier: ClassicCollectionViewCell.identifier, for: indexPath) as? ClassicCollectionViewCell else {
                return UICollectionViewCell()
            }
            let search = viewModel[indexPath.row]
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
        var selectedBooks: [BookViewModel] = []
        
        // Determine the correct section and populate selectedBooks accordingly
        switch indexPath.section {
        case Sections.readingNow.rawValue:
            selectedBooks = [gi[indexPath.row]]
        case Sections.recentlyRead.rawValue:
            selectedBooks = [viewModel[indexPath.row]]
        default:
            break
        }

        if let firstBook = selectedBooks.first,
           let infoLink = firstBook.infoLink,
           let url = URL(string: infoLink) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.modalPresentationStyle = .popover
            present(safariViewController, animated: true, completion: nil)
        } else {
            print("Invalid URL or selectedBooks is empty")
        }
    }

}



extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // Save the image to UserDefaults
            saveProfileImage(image)
            
            // Set the image to the profileImageView
            profileImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }

    private func saveProfileImage(_ image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            UserDefaults.standard.set(imageData, forKey: "profileImageData")
            UserDefaults.standard.synchronize()
        }
    }

    private func loadProfileImage() -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: "profileImageData"),
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
}

