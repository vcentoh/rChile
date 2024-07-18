//
//  configCameraView.swift
//  rChile
//
//  Created by Magik on 28/5/23.
//

import Foundation
import UIKit
import RxSwift
import UserNotifications

final class ConfigView: UIViewController {
    //MARK: View variables
    private var thumbnail: UIImage = UIImage()
    private var bag = DisposeBag()
    private var presenter: RedditPresenterProtocol
    var type: ConfigType = .camera
    
    // MARK: - UI elements
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isHidden = false
        image.tintColor = .darkGray
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var exposureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle( "Allow", for: .normal)
        button.setupRoundedCorners(radius: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var declineButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle( "Decline", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: RedditPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        addViews()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    // MARK: - UI
    private func addViews() {
        self.view.addSubview(imageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(exposureLabel)
        self.view.addSubview(acceptButton)
        self.view.addSubview(declineButton)
        self.setConstraints()
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -90).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: self.view.bounds.width *  0.7).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: self.view.bounds.height *  0.4).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.7).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        exposureLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        exposureLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exposureLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.7).isActive = true
        exposureLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        acceptButton.topAnchor.constraint(equalTo: exposureLabel.bottomAnchor, constant: 30).isActive = true
        acceptButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        acceptButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        acceptButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        declineButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor, constant: 10).isActive = true
        declineButton.centerXAnchor.constraint(equalTo: acceptButton.centerXAnchor).isActive = true
    }
    
    func cleanView() {
        imageView.image = nil
        titleLabel.text = ""
        exposureLabel.text = ""
        acceptButton.titleLabel?.text = ""
    }
    
    //MARK: View Configuration
    func configView(nType: ConfigType) {
        cleanView()
        self.type = nType
        switch type {
            case .camera:
                thumbnail = UIImage(named: "camera") ?? UIImage()
                imageView.image = thumbnail.withRenderingMode(.alwaysOriginal)
                titleLabel.text = "Camera Access"
                exposureLabel.text = "Please allow Access to your camera to take photos"
                acceptButton.titleLabel?.text = "Allow"
            case .location:
                thumbnail = UIImage(named: "geolocation") ?? UIImage()
                imageView.image = thumbnail.withRenderingMode(.alwaysOriginal)
                titleLabel.text = "Enable location services"
                exposureLabel.text = "We want to access your location only to provide a better experience"
                acceptButton.titleLabel?.text = "Enable"
            case .notification:
                thumbnail = UIImage(named: "notification") ?? UIImage()
                imageView.image = thumbnail.withRenderingMode(.alwaysOriginal)
                titleLabel.text = "Enable push notifications"
                exposureLabel.text = "Enable push notifications to let us send you personal news and updates "
                acceptButton.titleLabel?.text = "Enable"
            case .close:
                break;
        }
    }
    
    func openNativeView() {
//        switch type {
//            case .notification:
//                
//            case .location:
//                
//            case .camera:
//        }
    }
    
    //MARK: Action for the view
    func bindActions() {
        acceptButton.rx
            .tap
            .asObservable()
            .throttle(.milliseconds(250), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                guard let self = self else { return }
                presenter.nextView(type: self.type)

            })
            .disposed(by: bag)
        
        declineButton.rx
            .tap
            .asObservable()
            .throttle(.milliseconds(250), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                guard let self = self else { return }
                presenter.nextView(type: .close)
            })
            .disposed(by: bag)
    }
}
