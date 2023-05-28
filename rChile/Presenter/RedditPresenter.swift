//
//  RedditPresenter.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import RxSwift

protocol RedditPresenterProtocol {
    var redditThreads: RedditThreadData? { get }
    func fetchThreads() -> Observable<Void>
    func searchThreads()
    func launchConfig()
    func refreshThreads() -> Observable<Void>
}

final class RedditPresenter: RedditPresenterProtocol {
    var redditThreads: RedditThreadData?
    let interactor: RedditInteractorProtocol
    
    init(interactor: RedditInteractorProtocol) {
        self.interactor = interactor
        
    }
    
    func fetchThreads() -> Observable<Void>{
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
    
    func searchThreads() {
        
    }
    
    func launchConfig() {
        
    }
}
