//
//  AppCoordinator.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import Foundation

final class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        super.init(UINavigationController())
    }
    
    private func setup(with window: UIWindow?) {
        window?.rootViewController = ReelsViewController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
    }
    
    override func start() -> Observable<Void> {
        setup(with: window)
        showTab()
        return Observable.never()
    }
    
    private func showLogin() {
        navigationController.setNavigationBarHidden(true, animated: true)
//        let login = LoginCoordinator(navigationController)
//        coordinate(to: login)
//            .subscribe(onNext: { [weak self] in
//                switch $0 {
//                case .finish:
//                    self?.showTab()
//                }
//            })
//            .disposed(by: disposeBag)
    }

    private func showTab() {
        navigationController.setNavigationBarHidden(true, animated: true)
//        let tab = TabCoordinator(navigationController)
//        coordinate(to: tab)
//            .subscribe(onNext: { [weak self] in
//                switch $0 {
//                case .finish:
//                    self?.showLogin()
//                }
//            })
//            .disposed(by: disposeBag)
    }
}
