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
    case comments
}

final class ReelsViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let viewWillDisAppear: Observable<Void>
        let reelsTapped: Observable<Void>
        let reelsChanged: Observable<IndexPath>
        let reelsWillBeginDragging: Observable<Void>
        let reelsDidEndDragging: Observable<Void>
        let commentButtonTap: PublishSubject<String>
    }
    
    struct Output {
        let reelsList: Driver<[Reels]>
    }
    
    var disposeBag = DisposeBag()
    var reelsUseCase: ReelsUseCaseProtocol?
    let navigation = PublishSubject<ReelsNavigation>()
    private let videoController = VideoPlayerController.sharedVideoPlayer
    private let reelsList = BehaviorSubject<[Reels]>(value: [])
    private var currentIndexPath: IndexPath?
    let isPlaying = BehaviorRelay<Bool>(value: true)
    static let reload = PublishSubject<Void>()
    
    func transform(input: Input) -> Output {
        bind(input: input)
        return Output(
            reelsList: reelsList.asDriver(onErrorJustReturn: [])
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
        
        input.viewWillDisAppear
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                viewModel.isPlaying.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.reelsTapped
            .withUnretained(self)
            .subscribe { viewModel, _ in
                print("ReelsView가 클릭되었음")
                switch viewModel.isPlaying.value {
                case true:
                    viewModel.isPlaying.accept(false)
                case false:
                    viewModel.isPlaying.accept(true)
                }
            }
            .disposed(by: disposeBag)
        
        input.reelsChanged
            .withUnretained(self)
            .subscribe(onNext: { viewModel, indexPath in
                
                print("Reels가 바뀌었음")
                
                guard let currentIdxPath = viewModel.currentIndexPath else { return }
                                
                if currentIdxPath != indexPath {
                    
                    viewModel.currentIndexPath = indexPath
                    self.isPlaying.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        input.reelsWillBeginDragging
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                print("ReelsWillBeginDragging")
                viewModel.videoController.shouldPlay = false
            })
            .disposed(by: disposeBag)
        
        input.reelsDidEndDragging
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in
                print("ReelsDidEndDragging")
                viewModel.videoController.shouldPlay = true
            })
            .disposed(by: disposeBag)
        
        isPlaying.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewModel, isPlaying in
                switch isPlaying {
                case false:
                    print("일시정지")
                    viewModel.videoController.shouldPlay = false
                case true:
                    print("재생")
                    viewModel.videoController.shouldPlay = true
                }
            })
            .disposed(by: self.disposeBag)
        input.commentButtonTap
            .withUnretained(self)
            .subscribe(onNext: { viewModel, reelsID in
                viewModel.navigation.onNext(.comments)
            })
            .disposed(by: self.disposeBag)
        }
}

