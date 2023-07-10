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
import DRVideoController

enum ReelsNavigation {
    case finish
    case comments(Reels)
}

final class ReelsViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let viewWillDisAppear: Observable<Void>
        let viewDidAppear: Observable<Void>
        let reelsTapped: Observable<Void>
        let reelsChanged: Observable<IndexPath>
        let reelsWillBeginDragging: Observable<Void>
        let reelsDidEndDragging: Observable<Void>
        let commentButtonTap: PublishSubject<Reels>
    }
    
    struct Output {
        let reelsList: Driver<[Reels]>
        let shouldPlay: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    var reelsUseCase: ReelsUseCaseProtocol?
    let navigation = PublishSubject<ReelsNavigation>()
    let videoController = VideoPlayerController.sharedVideoPlayer
    let reelsList = BehaviorSubject<[Reels]>(value: [])
    let shouldPlay = BehaviorSubject<Bool>(value: false)
    private var currentIndexPath: IndexPath?
    static let reload = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        bind(input: input)
        return Output(
            reelsList: reelsList.asDriver(onErrorJustReturn: []),
            shouldPlay: shouldPlay.asDriver(onErrorJustReturn: false)
        )
    }
    
    func bind(input: Input) {
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

        input.reelsTapped
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                videoController.shouldPlay.toggle()
                shouldPlay.onNext(videoController.shouldPlay)
            })
            .disposed(by: disposeBag)
        
        input.viewWillDisAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                videoController.shouldPlay = false
                shouldPlay.onNext(videoController.shouldPlay)
            })
            .disposed(by: disposeBag)
        
        input.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                videoController.shouldPlay = true
                shouldPlay.onNext(videoController.shouldPlay)
            })
            .disposed(by: disposeBag)
        
        input.commentButtonTap
            .withUnretained(self)
            .subscribe(onNext: { viewModel, reels in
                viewModel.navigation.onNext(.comments(reels))
            })
            .disposed(by: self.disposeBag)
        }
}
