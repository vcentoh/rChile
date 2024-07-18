//
//  RedditPresenter.swift
//  rChile
//
//  Created by Magik on 27/5/23.
//

import Foundation
import RxSwift
import CoreData
import CoreLocation
import AVFoundation

//MARK: Presenter and its protocol
protocol RedditPresenterProtocol {
    var redditThreads: RedditThreadData? { get }
    func fetchThreads() -> Observable<Void>
    func searchThreads(target: String) -> Observable<Void>
    func premissionFlow(nav: UINavigationController)
    func refreshThreads() -> Observable<Void>
    func nextView(type: ConfigType)
}

final class RedditPresenter: RedditPresenterProtocol {
    
    var redditThreads: RedditThreadData?
    let interactor: RedditInteractorProtocol
    
    var locationStatus: Bool
    var cammeraStatus: Bool
    var pushStatus: Bool = false
    var navC: UINavigationController? = nil
    
    //setting the status of the permissions
    init(interactor: RedditInteractorProtocol) {
        self.interactor = interactor
        self.locationStatus = CLLocationManager.locationServicesEnabled()
        var  cameraAut = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAut == .authorized {
            self.cammeraStatus = true
        } else {
            self.cammeraStatus = false
        }
        var notCenter = UNUserNotificationCenter.current()
        notCenter.getNotificationSettings{ setting in
            switch setting.authorizationStatus {
                case .authorized:
                    self.pushStatus = true
                default:
                    self.pushStatus = false
            }
        }

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
    
    
    func premissionFlow(nav: UINavigationController) {
        self.navC = nav
        self.navC?.navigationBar.backItem?.hidesBackButton = true
        self.presentLocation()
    }
    
    func nextView(type: ConfigType) {
        var nuStep: ConfigType = .close
        switch type {
            case .notification, .close:
                nuStep = .close
            case .location:
                nuStep = .camera
            case .camera:
                nuStep = .notification
        }
        flow(step: nuStep)
    }
    
    func flow(step: ConfigType) {
        if !locationStatus && step == .location {
            self.presentLocation()
        } else if !cammeraStatus && step == .camera {
            self.presentCamera()
        } else if !pushStatus && step == .notification {
            self.presentPush()
        } else {
            self.navC?.popToRootViewController(animated: true)
        }
    }
    
    func presentLocation() {
        let vc = ConfigView(presenter: self)
        vc.configView(nType: .location)
        vc.modalPresentationStyle = .fullScreen
        self.navC?.pushViewController(vc, animated: true)
    }
    
    func presentCamera() {
        let vc = ConfigView(presenter: self)
        vc.configView(nType: .camera)
        vc.modalPresentationStyle = .fullScreen
        self.navC?.pushViewController(vc, animated: true)
    }
    
    func presentPush() {
        let vc = ConfigView(presenter: self)
        vc.configView(nType: .notification)
        vc.modalPresentationStyle = .fullScreen
        self.navC?.pushViewController(vc, animated: true)
    }
}

enum ConfigType {
    case notification
    case location
    case camera
    case close
}
