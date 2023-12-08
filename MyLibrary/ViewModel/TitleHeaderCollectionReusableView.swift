//
//  TitleHeaderCollectionReusableView.swift
//  Books
//
//  Created by Jennifer Chukwuemeka on 15/11/2023.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifer = "TitleHeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 15, y: 0, width: self.frame.width-30, height: self.frame.height)
    }
    func configure(with title: String) {
        label.text = title
    }
    
}
