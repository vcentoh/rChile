//
//  configCameraView.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import UIKit
import RxSwift

final class ConfigView: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.isHidden = false
        image.tintColor = .darkGray
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var exposureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = ""
        return button
    }()
    
    private lazy var declineButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Decline"
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(exposureLabel)
        self.view.addSubview(acceptButton)
        self.view.addSubview(declineButton)
        self.setConstraints()
    }
    
    private func setConstraints() {
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width *  0.7).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.view.bounds.height *  0.4).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.7).isActive = true
        
        exposureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        exposureLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        exposureLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.7).isActive = true
        
        acceptButton.topAnchor.constraint(equalTo: exposureLabel.bottomAnchor, constant: 30).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        
        declineButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor, constant: 30).isActive = true
        declineButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        declineButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
    }
}

enum configType {
    case camera
    case location
    case notification
}
