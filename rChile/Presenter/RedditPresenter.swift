//
//  RedditPresenter.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import RxSwift

protocol RedditPresenterProtocol {
    func fetchThreads(paginated: String) -> Observable<RedditThreadData>
    func searchThreads()
    func launchConfig()
}

final class RedditPresenter: RedditPresenterProtocol {
    private var redditThreads: RedditThreadData
    let interactor: RedditInteractorProtocol
    
    init(interactor: RedditInteractorProtocol) {
        self.interactor = interactor
    }
    
    func fetchThreads(paginated: String = "") -> Observable<RedditThreadData>{
       return interactor.fetchThreads(paginated: paginated)
    }
    
    func searchThreads() {
        <#code#>
    }
    
    func launchConfig() {
        <#code#>
    }
    
    
}
