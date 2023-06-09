//
//  RedditPresenter.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import RxSwift
import CoreData

//MARK: Presenter and its protocol
protocol RedditPresenterProtocol {
    var redditThreads: RedditThreadData? { get }
    func fetchThreads() -> Observable<Void>
    func searchThreads(target: String) -> Observable<Void>
    func premissionFlow() -> UIViewController
    func refreshThreads() -> Observable<Void>
    func nextView(type: ConfigType)
}

final class RedditPresenter: RedditPresenterProtocol {
    
    var redditThreads: RedditThreadData?
    let interactor: RedditInteractorProtocol
    
    init(interactor: RedditInteractorProtocol) {
        self.interactor = interactor
        
    }
    
    func fetchThreads() -> Observable<Void> {
        let pagination = redditThreads?.after ?? ""
        return interactor.fetchThreads(paginated: pagination)
            .flatMap { [weak self] threads in
                guard ((self?.redditThreads) != nil) else {
                    self?.redditThreads = threads
                    return Observable.just(())
                }
                self?.redditThreads?.after = threads.after
                self?.redditThreads?.children.append(contentsOf: threads.children)
                return Observable.just(())
            }
    }
    
    func refreshThreads() -> Observable<Void> {
        redditThreads = nil
        return fetchThreads()
    }
    
    func searchThreads(target: String) -> Observable<Void> {
        let pagination = redditThreads?.after ?? ""
        return interactor.search(target: target, paginated: pagination)
            .flatMap { [weak self] threads in
                guard ((self?.redditThreads) != nil) else {
                    self?.redditThreads = threads
                    return Observable.just(())
                }
                self?.redditThreads?.after = threads.after
                self?.redditThreads = threads
                return Observable.just(())
            }
    }
    
    
    func premissionFlow() -> UIViewController {
        let vc = ConfigView(presenter: self)
        vc.configView(nType: .location)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    func nextView(type: ConfigType) {
        let vc = ConfigView(presenter: self)
        vc.modalPresentationStyle = .fullScreen
        switch type {
            case .location:
                break;
            case .notification:
                vc.configView(nType: .location)
            case .camera:
                vc.configView(nType: .notification)
        }
    }
}
