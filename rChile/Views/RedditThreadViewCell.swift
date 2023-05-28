//
//  ThreadViewCell.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import UIKit
import Kingfisher

final class RedditThreadViewCell: UICollectionViewCell {
    
    static var identifier = "RedditThreadViewCell"
    
    lazy var thumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        image.isHidden = false
        image.image = UIImage(systemName: "chevron.up")
        image.tintColor = .darkGray
        return image
    }()
    
    lazy var downArrow: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.isHidden = false
        image.image = UIImage(systemName: "chevron.down")
        image.tintColor = .darkGray
        return image
    }()
    
    lazy var scoreLabel: UILabel  = {
        let label = UILabel()
        label.textAlignment = .center
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
        image.layer.cornerRadius = 0.3
        return image
    }()
    
    lazy var commentLabel: UILabel  = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    lazy var scoreFrame: UIView = {
        let height = self.frame.height
        let width = self.frame.width * 0.2
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        self.addSubview(thumbnailImage)
        self.addSubview(titleLabel)
        self.addSubview(commentBubble)
        self.addSubview(commentLabel)
        self.contentView.layer.cornerRadius = 0.3
        addScoreView()
    }
    
    func addScoreView() {
        self.addSubview(scoreFrame)
        scoreFrame.addSubview(upArrow)
        scoreFrame.addSubview(scoreLabel)
        scoreFrame.addSubview(downArrow)
    }
    
    func setConstraints() {
        thumbnailImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbnailImage.leadingAnchor.constraint(equalTo: self.scoreFrame.trailingAnchor).isActive = true
        thumbnailImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        thumbnailImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        
        setScoreConstraints()
    }
    
    func setScoreConstraints() {
        scoreFrame.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scoreFrame.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scoreFrame.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive =  true
        
        upArrow.topAnchor.constraint(equalTo: scoreFrame.topAnchor, constant: 5).isActive = true
        upArrow.widthAnchor.constraint(equalTo: scoreFrame.widthAnchor, multiplier: 0.7).isActive = true
        upArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: upArrow.bottomAnchor).isActive =  true
        scoreLabel.widthAnchor.constraint(equalTo: scoreFrame.widthAnchor, multiplier: 0.7).isActive = true
        scoreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        scoreLabel.centerYAnchor.constraint(equalTo: scoreFrame.centerYAnchor).isActive = true
        
        downArrow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        downArrow.widthAnchor.constraint(equalTo: scoreFrame.widthAnchor, multiplier: 0.7).isActive = true
        downArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupCell(postData: ChildData?) {
        guard let postData = postData else { return }
        titleLabel.text = postData.title
        loadImage(url: postData.url)
        scoreLabel.text =  String(postData.score)
    }
    
    private func loadImage(url: String) {
        let varUrl = URL(string: url)
        thumbnailImage.kf.setImage(with: varUrl)
//        let processor = DownsamplingImageProcessor(size: thumbnailImage.bounds.size)
//        |> RoundCornerImageProcessor(cornerRadius: 20)
//        thumbnailImage.kf.indicatorType = .activity
//        thumbnailImage.kf.setImage(
//            with: varUrl,
//            placeholder: UIImage(named: "placeholderImage"),
//            options: [
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(1)),
//                .cacheOriginalImage
//            ])
//        {
//            result in
//            switch result {
//                case .success(let value):
//                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                case .failure(let error):
//                    print("Job failed: \(error.localizedDescription)")
//            }
//        }
    }
}
