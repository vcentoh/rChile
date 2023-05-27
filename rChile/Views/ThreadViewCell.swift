//
//  ThreadViewCell.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import UIKit

final class RedditThreadViewCell: UICollectionView {
    
    lazy var thumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    lazy var upArrow: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var downArrow: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var scoreLabel: UILabel  = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    lazy var commentBubble: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var commentLabel: UILabel  = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        self.addSubview(thumbnailImage)
        self.addSubview(titleLabel)
        self.addSubview(upArrow)
        self.addSubview(scoreLabel)
        self.addSubview(downArrow)
        self.addSubview(commentBubble)
        self.addSubview(commentLabel)
    }
    
    func setConstraints() {
        thumbnailImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbnailImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thumbnailImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        thumbnailImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        
        
    }
}
