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
}

final class ReelsViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let reelsTapped: Observable<Void>
        let reelsChanged: Observable<Void>
    }
    
    struct Output {
        let reelsList: Driver<[Reels]>
    }
    
    var disposeBag = DisposeBag()
    var reelsUseCase: ReelsUseCaseProtocol?
    let navigation = PublishSubject<ReelsNavigation>()
    private let videoController = VideoPlayerController.sharedVideoPlayer
    private let reelsList = BehaviorSubject<[Reels]>(value: [])
    private var currentReels: Reels?
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
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.reelsUseCase?.list().asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case let .success(reelsList):
                    viewModel.reelsList.onNext(reelsList)
                    guard let firstReels = reelsList.first else { return }
                    viewModel.currentReels = firstReels
                case .failure:
                    viewModel.reelsList.onNext([])
                }
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
            .subscribe(onNext: { viewModel, _ in
                print("Reels가 바뀌었음")
                if let layer = viewModel.videoController.currentLayer, let url = viewModel.currentReels?.videoURL {
                    viewModel.videoController.playVideo(withLayer: layer, url: url)
                    viewModel.isPlaying.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        isPlaying.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { viewModel, isPlaying in
                switch isPlaying {
                case true:
                    print("일시정지")
                    if let layer = viewModel.videoController.currentLayer, let url = viewModel.currentReels?.videoURL {
                        viewModel.videoController.pauseVideo(forLayer: layer, url: url)
                        print(layer, url)
                    }
                case false:
                    print("재생")
                    if let layer = viewModel.videoController.currentLayer, let url = viewModel.currentReels?.videoURL {
                        viewModel.videoController.playVideo(withLayer: layer, url: url)
                        print(layer, url)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
