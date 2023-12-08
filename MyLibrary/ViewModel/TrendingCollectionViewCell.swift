//
//  TrendingCollectionViewCell.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 14/11/2023.
//

import UIKit
import SDWebImage


class TrendingCollectionViewCell: UICollectionViewCell {
    static let identifier = "TrendingCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0  // Set to 1 to allow single line
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var RatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment  = .right
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(RatingLabel)
        setUpLayer()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
        contentView.layer.shadowOpacity = 0.3
    }
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for the contentView
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Constraints for the imageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120), // Adjust the height based on your needs
            
            // Constraints for the titleLabel
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5),
            
            RatingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            RatingLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            RatingLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
            // Constraints for the authorLabel
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
           
        ])
    }


    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        RatingLabel.text = nil
    }
    public func configure(viewModel: BookViewModel) {
       
       
        
        titleLabel.text = viewModel.title


        if let averageRating = viewModel.averageRating {
                RatingLabel.text = "\(averageRating) ⭐️"
            } else {
                RatingLabel.text = nil  // or set a default value
            }


        if let authors = viewModel.authors, !authors.isEmpty {
            let authorString = authors.joined(separator: ", ")
            authorLabel.text = "by: \(authorString)"
        } else {
            authorLabel.text = "No author available"
        }

        if let thumbnailURL = viewModel.thumbnailURL?.absoluteString, let url = URL(string: thumbnailURL) {
            imageView.sd_setImage(with: url)
        } else {
            // Handle the case where thumbnailURL is not a valid URL or is nil
            imageView.image = UIImage(named: "placeholderImage")
        }
    }







    
    
}
extension Double {
    func toString() -> String {
        return String(self)
    }
}
