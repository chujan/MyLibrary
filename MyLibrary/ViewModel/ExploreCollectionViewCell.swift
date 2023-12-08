//
//  ExploreCollectionViewCell.swift
//  MyLibrary
//
//  Created by Jennifer Chukwuemeka on 22/11/2023.
//

import UIKit



class ExploreCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreCollectionViewCell"
    var bookmarkButtonTapHandler: (() -> Void)?

       
    private var viewModel: BookViewModel?
    
    private var isDescriptionExpanded = false
    private let shortDescriptionMaxLines = 3
    
    private let readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
     
    
    
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        // label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true  // Add this line
        return label
    }()
    
    
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private var RatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    private var publisherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var printLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var printCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    private var availableLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelAction(gesture:)))

//      //  let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//               contentView.addGestureRecognizer(tapGesture)
//        contentView.addGestureRecognizer(tapGesture)
        contentView.addGestureRecognizer(tap)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(RatingLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(readMoreButton)
        contentView.addSubview(availableLabel)
        contentView.addSubview(printLabel)
        contentView.addSubview(publisherLabel)
        contentView.addSubview(printCountLabel)
       // contentView.backgroundColor = .red // or any color for visibility

      
        
        contentView.bringSubviewToFront(readMoreButton)
        readMoreButton.addGestureRecognizer(tap)
        readMoreButton.setTitle("Read more", for: .normal)
        
        
       
        
        
        // setUpLayer()
        setUpConstraints()
       
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

    
    @objc func labelAction(gesture: UITapGestureRecognizer) {
        if descriptionLabel.numberOfLines == 0 {
            descriptionLabel.numberOfLines = 2
            readMoreButton.isHidden = false
        } else {
            descriptionLabel.numberOfLines = 0
            readMoreButton.isHidden = true
        }
    }


    
    
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        descriptionLabel.text = nil
        authorLabel.text = nil
        readMoreButton.setTitle("Read More", for: .normal)
        categoryLabel.text = nil
        availableLabel.text = nil
        printLabel.text = nil
        publisherLabel.text = nil
        printCountLabel.text = nil
        descriptionLabel.numberOfLines = shortDescriptionMaxLines
        isDescriptionExpanded = false
        
        
    }
    
    
    
    
    
    
    
    private func setUpLayer() {
        // contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    
    private func setUpConstraints() {
        contentView.isUserInteractionEnabled = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true


        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),

            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            availableLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: +20),
            availableLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            RatingLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            RatingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryLabel.topAnchor.constraint(equalTo: RatingLabel.bottomAnchor, constant: 20),

            publisherLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 20),
            publisherLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            publisherLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            printLabel.topAnchor.constraint(equalTo: publisherLabel.bottomAnchor, constant: 20),
            printLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            printLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            printCountLabel.topAnchor.constraint(equalTo: printLabel.bottomAnchor, constant: 20),
            printCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            printCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),

            descriptionLabel.topAnchor.constraint(equalTo: printCountLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),

            readMoreButton.topAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 10),
            readMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    


    
    
    
  
    
    public func configure(viewModel: BookViewModel) {
        
        if let pageCount = viewModel.pageCount {
            printCountLabel.text = "Pages: \(pageCount)"
        } else {
            printCountLabel.text = "Page count not available"
        }

 
        if let publisher = viewModel.publisher, let publishedDate = viewModel.publishedDate {
                publisherLabel.text = "Publisher: \(publisher), \(publishedDate)"
            } else {
                // Handle the case where either publisher or publishedDate is nil
                // You can set a default message or leave the text empty
                publisherLabel.text = "Published information not available"
            }
        
       
        if let industryIdentifiers = viewModel.industryIdentifiers, !industryIdentifiers.isEmpty {
                var identifiersString = ""
                for identifier in industryIdentifiers {
                    let identifierString = "Type: \(identifier.type), Identifier: \(identifier.identifier)"
                    identifiersString += "\(identifierString)\n"
                }
                // Display or use identifiersString as needed
               printLabel.text = identifiersString
            } else {
                printLabel.text = "No industry identifiers available"
            }
        
        if let averageRating = viewModel.averageRating {
               var ratingText = "Rating: \(averageRating) \(generateStarString(for: averageRating))"
               
               if let ratingsCount = viewModel.ratingsCount {
                   ratingText += " (\(ratingsCount) ratings)"
               }
               
               RatingLabel.text = ratingText
           } else {
               RatingLabel.text = "No Rating available"  // or set a default value
           }
        
        
        if let authors = viewModel.authors, !authors.isEmpty {
            let authorString = authors.joined(separator: ", ")
            authorLabel.text = "by: \(authorString)"
        } else {
            authorLabel.text = "No author available"
            
        }
        
        if let categories = viewModel.categories, !categories.isEmpty {
            let categoriesString = categories.joined(separator: ", ")
            categoryLabel.text = "Genre: \(categoriesString)"
        } else {
            categoryLabel.text = "No Genre available"
            
        }
        
        if let thumbnailURL = viewModel.thumbnailURL?.absoluteString, let url = URL(string: thumbnailURL) {
            imageView.sd_setImage(with: url)
        } else {
            // Handle the case where thumbnailURL is not a valid URL or is nil
            imageView.image = UIImage(named: "placeholderImage")
        }
        
        descriptionLabel.text = viewModel.description
        
        let availabilityText: String
        let availabilityColor: UIColor

        if let isAvailable = viewModel.isAvailable {
            availabilityText = isAvailable ? "Available" : "Not Available"
            availabilityColor = isAvailable ? .systemGreen : .systemRed
            
        } else {
            availabilityText = "Availability not specified"
            availabilityColor = .systemGray
        }

        availableLabel.text = availabilityText
        availableLabel.textColor = availabilityColor


   }
    private func generateStarString(for rating: Double) -> String {
        let starCount = Int(rating.rounded())
        return String(repeating: "⭐️", count: starCount)
    }
    
    
    
}
