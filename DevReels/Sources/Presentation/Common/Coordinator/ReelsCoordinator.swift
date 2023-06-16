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
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.pop(animated: false)
                }
            })
    }
    
    // 릴스로 이동하는건 아니겠지만 일단 릴스로 네이밍해둠
    func showReels() {
        guard let viewModel = DIContainer.shared.container.resolve(ReelsViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
    }
}
