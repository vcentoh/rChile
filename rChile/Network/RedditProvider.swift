//
//  APIreddit.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import Moya
import RxRelay

let apiURL = "https://www.reddit.com/r/chile/new/"
let limitPerPage = 100

enum RedditProvider {
    case getThreads(limitPerPage: Int, pagination: String?)
}


extension RedditProvider: TargetType {
    var path: String {
        return ".json"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
            case .getThreads(let limitPerPage, let pagination):
                let params: [String: Any] = ["limit": limitPerPage, "after": pagination ?? ""]
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers:  [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var baseURL: URL {
        return URL(string: apiURL) ?? URL(fileURLWithPath: "")
    }
}
