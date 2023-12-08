//
//  SearchTableViewCell.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 16/11/2023.
//

import UIKit
import SDWebImage

class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
       
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
        
    }()
    
    private let Ratinglabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(searchImageView)
       contentView.addSubview(label)
        contentView.addSubview(Ratinglabel)
        setUpLayer()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchImageView.image = nil
        label.text = nil
        Ratinglabel.text = nil
    }
    private func setUpLayer() {
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        contentView.layer.shadowOpacity = 0.3
    }
    
    
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            searchImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            searchImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            searchImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            searchImageView.widthAnchor.constraint(equalToConstant: 100),
            searchImageView.heightAnchor.constraint(equalToConstant: 100), // Set the desired height

            label.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 25),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            Ratinglabel.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 50),
            Ratinglabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
           
        ])
    }

    public func configure(viewModel: BookViewModel) {
        if let averageRating = viewModel.averageRating {
               var ratingText = "Rating: \(averageRating) \(generateStarString(for: averageRating))"
               
               if let ratingsCount = viewModel.ratingsCount {
                   ratingText += " (\(ratingsCount) ratings)"
               }
               
               Ratinglabel.text = ratingText
           } else {
               Ratinglabel.text = "No Rating available"  // or set a default value
           }
        
        
        if let authors = viewModel.authors, !authors.isEmpty {
            let authorString = authors.joined(separator: ", ")
            label.text = "Authored by: \(authorString)"
        } else {
            label.text = "No author available"
        }

        if let thumbnailURL = viewModel.thumbnailURL?.absoluteString, let url = URL(string: thumbnailURL) {
           searchImageView.sd_setImage(with: url)
        } else {
            // Handle the case where thumbnailURL is not a valid URL or is nil
           searchImageView.image = UIImage(named: "placeholderImage")
        }
    }
    private func generateStarString(for rating: Double) -> String {
        let starCount = Int(rating.rounded())
        return String(repeating: "⭐️", count: starCount)
    }
    
        
    }
    
   

    // Call this method
   

    

