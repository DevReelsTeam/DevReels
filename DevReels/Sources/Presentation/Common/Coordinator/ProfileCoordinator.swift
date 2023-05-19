//
//  ProfileCoordinator.swift
//  DevReels
//
//  Created by Sh Hong on 2023/05/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

enum ProfileCoordinatorResult {
    case finish
    case back
}

final class ProfileCoordinator: BaseCoordinator<ProfileCoordinatorResult> {
    
    private let finish = PublishSubject<ProfileCoordinatorResult>()
    
    override func start() -> Observable<ProfileCoordinatorResult> {
        return finish
            .do(onNext: { [weak self] _ in
                self?.pop(animated: true)
            })
    }
    
    // MARK: - 프로필
    
    func showProfile() {
        guard let viewModel = DIContainer.shared.container.resolve(ProfileViewModel.self) else { return }
        
        viewModel.navigation
            .bind { [weak self] navigation in
                switch navigation {
                case .editProfile:
                    self?.showEditProfile()
                case .blog, .github: break
                case .follower, .following: break
                case .post: break
                case .finish:
                    self?.finish.onNext(.back)
                }
            }
            .disposed(by: disposeBag)
        
        let viewController = ProfileViewController(viewModel: viewModel)
        
        push(viewController, animated: true)
    }
    
    // MARK: - 프로필 수정
    
    func showEditProfile() {
        print("Move To Profile Edit")
    }
}
