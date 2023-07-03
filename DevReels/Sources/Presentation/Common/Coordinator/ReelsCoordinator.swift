//
//  ReelsCoordinator.swift
//  DevReels
//
//  Created by Jerry on 2023/06/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

enum ReelsCoordinatorResult {
    case finish
}

final class ReelsCoordinator: BaseCoordinator<ReelsCoordinatorResult> {
    
    private let finish = PublishSubject<ReelsCoordinatorResult>()
    
    override func start() -> Observable<ReelsCoordinatorResult> {
        showReels()
//        return Observable.never()
//        showReels()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.pop(animated: false)
                }
            })
    }
    
    func showReels() {
        guard let viewModel = DIContainer.shared.container.resolve(ReelsViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .comments:
                    self?.showComment()
                }
            })
            .disposed(by: disposeBag)
        let viewController = ReelsViewController(viewModel: viewModel)
        push(viewController, animated: true, isRoot: true)
    }
    
    func showComment() {
        let viewModel = CommentViewModel()
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.pop(animated: true)
                    self?.setTabBarHidden(false)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = CommentViewController(viewModel: viewModel)
        self.setNavigationBarHidden(false, animated: false)
        self.setTabBarHidden(true)
        push(viewController, animated: true)
    }
}
