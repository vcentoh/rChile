//
//  ThreadViewCellViewController.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController  {
    
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var searchBar: SearchBarComponent?
    
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
    
    private func setupSearchBar() {
        let searchComponent = SearchBarComponent(frame: .zero)
        searchComponent.base.translatesAutoresizingMaskIntoConstraints = false
        searchComponent.placeholder = "Search"
        view.addSubview(searchComponent.base)
        self.searchBar = searchComponent
        setSearchViewConstraints(with: searchComponent.base)

        searchComponent.actions.text
            .subscribe(onNext: { [weak self] query in
                guard let self = self, query.isEmpty == false else { return }
                self.search(query: query)
            }).disposed(by: bag)
        
        searchComponent.actions.didSearch
            .subscribe(onNext: { [weak self] query in
                guard let self = self,  query.isEmpty == false else { return }
                self.search(query: query)
            }).disposed(by: bag)
    }
    
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
        setupSearchBar()
        setConstraints()
    }
    
    func setConstraints() {
        guard let searchBar else  { return }
        collectionView.topAnchor.constraint(equalTo: searchBar.base.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func setSearchViewConstraints(with view: UIView) {
        view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        view.widthAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 1).isActive = true
        view.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -15).isActive = true
    }
    
    private func search(query: String) {
        self.presenter.searchThreads(target: query)
            .subscribe(onNext: { [weak self]  in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }, onError: { error in
                
            }).disposed(by: bag)
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
                                                        for: indexPath) as? RedditThreadViewCell else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setupCell(postData: presenter.redditThreads?.children[indexPath.row].data)
        return cell
    }
}

// MARK: - Collection Flow Layout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 220)
    }
}
