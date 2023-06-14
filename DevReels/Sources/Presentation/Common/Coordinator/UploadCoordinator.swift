//
//  UploadCoordinator.swift
//  DevReels
//
//  Created by HoJun on 2023/05/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

import RxSwift

enum UploadCoordinatorResult {
    case finish
}

final class UploadCoordinator: BaseCoordinator<UploadCoordinatorResult> {
    
    private let finish = PublishSubject<UploadCoordinatorResult>()
    
    override func start() -> Observable<UploadCoordinatorResult> {
        showVideoTrimmer()
        return Observable.never()
    }
    
    
    // MARK: - 비디오 트리밍
    
    func showVideoTrimmer() {
//        guard let viewModel = DIContainer.shared.container.resolve(ProfileViewModel.self) else { return }
        
        let viewModel = VideoTrimmerViewModel()
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case let .details(seletedVideoURL):
                    self?.showVideoDetails(seletedVideoURL: seletedVideoURL)
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = VideoTrimmerViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 비디오 상세
    
    func showVideoDetails(seletedVideoURL: URL) {
        
        let viewModel = VideoDetailsViewModel()
        
        viewModel.seletedVideoURL = seletedVideoURL
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .back:
                    self?.pop(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = VideoDetailsViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
}
