//
//  FlowStartingPoint.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import UIKit
import Moya

//MARK: Launching the view.
final class FlowStartingPoint {
    
    var navigationController: UINavigationController?
    
    var provider: MoyaProvider<RedditProvider> =  MoyaProvider<RedditProvider>()
    
    init(with window: UIWindow) {
        let interactor = RedditInteractor(provider: provider)
        let presenter = RedditPresenter(interactor: interactor)
        let vc = HomeViewController(with: presenter)
        navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
