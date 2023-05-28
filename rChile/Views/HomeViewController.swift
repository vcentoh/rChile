//
//  ThreadViewCellViewController.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import UIKit
import RxSwift

final class HomeViewController: UIViewController  {
    
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    private lazy var searchBar: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
    
    private lazy var searchText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Escriba un filtro a buscar"
        textField.textColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        let image =  UIImage(systemName: "magnifyingglass")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 0.5
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(RedditThreadViewCell.self,
                            forCellWithReuseIdentifier: RedditThreadViewCell.identifier)
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let presenter: RedditPresenterProtocol
    
    init(with presenter: RedditPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubviews()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addSubviews() {
        self.view.addSubview(collectionView)
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.refreshControl = self.refreshControl
        setSearchBar()
        setConstraints()
    }
    
    func setConstraints() {
        setSearchBarConstraints()
        collectionView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func setSearchBar() {
        self.view.addSubview(searchBar)
        searchBar.addSubview(self.searchText)
        searchBar.addSubview(self.searchButton)
    }
    
    func setSearchBarConstraints() {
        navigationController?.isNavigationBarHidden = true
        
        self.searchBar.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 1).isActive = true
        self.searchBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 5).isActive = true
        self.searchButton.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -25).isActive = true
        self.searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.searchText.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 5).isActive = true
        self.searchText.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 2).isActive = true
        self.searchText.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: -2).isActive = true
        self.searchText.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -5).isActive = true
    }
    
    private func fetchData() {
        presenter.fetchThreads()
            .subscribe(onNext: { [weak self] threadData in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }).disposed(by: bag)
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        presenter.refreshThreads()
            .subscribe(onNext: { [weak self] threadData in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
            }).disposed(by: bag)
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let threads = presenter.redditThreads else { return }
        if indexPath.row == threads.children.count - 1 {
            presenter.fetchThreads()
                .subscribe(onNext: { _ in
                    collectionView.performBatchUpdates({
                        collectionView.reloadSections([0])
                    })
                }).disposed(by: bag)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.redditThreads?.children.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RedditThreadViewCell.identifier,
                                                        for: indexPath) as? RedditThreadViewCell,
              let posts = presenter.redditThreads else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setupCell(postData: posts.children[indexPath.row].data)
        return cell
    }
}

// MARK: - Collection Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 220)
    }
}
