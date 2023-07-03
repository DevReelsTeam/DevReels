//
//  ReelsViewModel.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ReelsNavigation {
    case finish
    case comments
}

final class ReelsViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let commentButtonTap: PublishSubject<String>
    }
    
    struct Output {
        let reelsList: Driver<[Reels]>
    }
    
    var disposeBag = DisposeBag()
    var reelsUseCase: ReelsUseCaseProtocol?
    let navigation = PublishSubject<ReelsNavigation>()
    let currentReels = PublishSubject<Reels>()
    private let reelsList = BehaviorSubject<[Reels]>(value: [])
    static let reload = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        bindRefresh(input: input)
        return Output(
            reelsList: reelsList.asDriver(onErrorJustReturn: [])
        )
    }
    
    func bindRefresh(input: Input) {
        input.viewWillAppear
            .take(1)
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.reelsUseCase?.list().asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case let .success(reelsList):
                    viewModel.reelsList.onNext(reelsList)
                case .failure:
                    viewModel.reelsList.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        input.commentButtonTap
            .withUnretained(self)
            .subscribe(onNext: { viewModel, reelsID in
                viewModel.navigation.onNext(.comments)
            })
            .disposed(by: disposeBag)
    }
}
