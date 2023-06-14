//
//  TabCoordinator.swift
//  DevReels
//
//  Created by HoJun on 2023/05/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

import RxSwift

enum TabCoordinatorResult {
    case finish
}

final class TabCoordinator: BaseCoordinator<TabCoordinatorResult> {
    
    enum Tab: Int, CaseIterable {
        case reels
        case upload
        case profile

        var title: String {
            switch self {
            case .reels: return "릴스"
            case .upload: return "업로드"
            case .profile: return "프로필"
            }
        }

        var image: String {
            switch self {
            case .reels: return "house.fill"
            case .upload: return "plus.circle"
            case .profile: return "person.crop.circle"
            }
        }
    }
    
    private var tabBarController = UITabBarController()
    private let finish = PublishSubject<TabCoordinatorResult>()
    
    override func start() -> Observable<TabCoordinatorResult> {
        push(tabBarController, animated: true, isRoot: true)
        setup()
        return finish
    }
    
    private func setup() {
        var rootViewControllers: [UINavigationController] = []
        
        Tab.allCases.forEach {
            let navigationController = navigationController(tab: $0)
            rootViewControllers.append(navigationController)
            
            switch $0 {
//            case .study: showReels(navigationController)
            case .upload: showUpload(navigationController)
//            case .profile: showProfile(navigationController)
            default: break
            }
        }
        
        tabBarController.setViewControllers(rootViewControllers, animated: false)
    }
    
    private func navigationController(tab: Tab) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.image),
            tag: tab.rawValue
        )
        navigationController.tabBarItem = tabBarItem
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    private func showUpload(_ root: UINavigationController) {
        let child = UploadCoordinator(root)
        coordinate(to: child)
            .subscribe(onNext: { [weak self] in
            switch $0 {
            case .finish:
                self?.finish.onNext(.finish)
            }
        })
            .disposed(by: disposeBag)
    }
    
//    private func showStudyList(_ root: UINavigationController) {
//        let child = StudyListCoordinator(root)
//        coordinate(to: child)
//            .subscribe(onNext: { [weak self] in
//                switch $0 {
//                case .finish:
//                    self?.finish.onNext(.finish)
//                }
//            })
//            .disposed(by: disposeBag)
//    }

}
