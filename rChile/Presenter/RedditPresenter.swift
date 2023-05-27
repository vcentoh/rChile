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
    func fetchThreads() -> Observable<RedditThreadData>
    func searchThreads()
    func launchConfig()
}

final class RedditPresenter: RedditPresenterProtocol {
    var redditThreads: RedditThreadData?
    let interactor: RedditInteractorProtocol
    
    init(interactor: RedditInteractorProtocol) {
        self.interactor = interactor
        
    }
    
    func fetchThreads() -> Observable<RedditThreadData>{
    
        let pagination = redditThreads?.after ?? ""
        return interactor.fetchThreads(paginated: pagination)
            .flatMap { [weak self] threads in
                self?.redditThreads = threads
                return Observable.just(threads)
            }
    }
    
    func searchThreads() {
        
    }
    
    func launchConfig() {
        
    }
}
