//
//  RedditInteractor.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import RxSwift
import Moya

//MARK: Interacto, and its protocol.
protocol RedditInteractorProtocol  {
    func fetchThreads(paginated: String?) -> Observable<RedditThreadData>
    func search(target: String, paginated: String?) -> Observable<RedditThreadData>
}

final class RedditInteractor: RedditInteractorProtocol {
    private let limit = 100
    private let provider: MoyaProvider<RedditProvider>
    
    init(provider: MoyaProvider<RedditProvider>){
        self.provider = provider
    }
    
    //MARK: Get the threads from target
    func fetchThreads(paginated: String?) -> Observable<RedditThreadData> {
        return provider.rx.request(.getThreads(limitPerPage: limit, pagination: paginated))
            .asObservable()
            .map(RedditThread.self)
            .retry()
            .flatMap({ redditData -> Observable<RedditThreadData> in
                let filterData = redditData.data.children.filter({$0.data.linkFlairText == LinkFlairTextType.shitposting.rawValue || $0.data.postHint == PostHintType.threadImage.rawValue })
                let filterRedditData = RedditThreadData(after: redditData.data.after, children: filterData)
                return .just(filterRedditData)
            })
    }
    
    //MARK: Search threads by a Query
    func search(target: String, paginated: String?) -> Observable<RedditThreadData> {
        return provider.rx.request(.searchThreads(genre: target, limitPerPage: limit, pagination: ""))
            .asObservable()
            .map(RedditThread.self)
            .retry(2)
            .flatMapLatest({ redditData -> Observable<RedditThreadData> in
                let filterData = redditData.data.children.filter({$0.data.linkFlairText == LinkFlairTextType.shitposting.rawValue || $0.data.postHint == PostHintType.threadImage.rawValue })
                let filterRedditData = RedditThreadData(after: redditData.data.after, children: filterData)
                return .just(filterRedditData)
            })
    }
}

