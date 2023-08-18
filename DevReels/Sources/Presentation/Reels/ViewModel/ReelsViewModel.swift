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
        let reelsWillDisplay: Observable<IndexPath>
        let reelsEndDisplay: Observable<IndexPath>
        let reelsWillBeginDragging: Observable<Void>
        let reelsDidEndDragging: Observable<Void>
        let commentButtonTap: PublishSubject<Reels>
        let heartButtonTap: PublishSubject<Int>
    }
    
    struct Output {
        let reelsList: Driver<[Reels]>
        let shouldPlay: Driver<Bool>
        let isHeartFilled: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    var reelsUseCase: ReelsUseCaseProtocol?
    var userUseCase: UserUseCaseProtocol?
    var updateHeartsUseCase: UpdateHeartsUseCaseProtocol?
    let currentReels = BehaviorSubject<Reels?>(value: nil)
    let navigation = PublishSubject<ReelsNavigation>()
    let isHeartFilled = BehaviorSubject<Bool>(value: false)
    let reelsList = BehaviorSubject<[Reels]>(value: [])
    let currentUser = BehaviorSubject<User?>(value: nil)
    let shouldPlay = BehaviorSubject<Bool>(value: false)
    static let reload = PublishSubject<Void>()
    let videoController = VideoPlayerController.sharedVideoPlayer
    
    func transform(input: Input) -> Output {
        bind(input: input)
        return Output(
            reelsList: reelsList.asDriver(onErrorJustReturn: []),
            shouldPlay: shouldPlay.asDriver(onErrorJustReturn: false),
            isHeartFilled: isHeartFilled.asDriver(onErrorJustReturn: false)
        )
    }
    
    func bind(input: Input) {
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.reelsUseCase?.list().asResult() ?? .empty()
            }
            .observe(on: MainScheduler.asyncInstance)
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
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.userUseCase?.currentUser().asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                viewModel.videoController.shouldPlay = true
                viewModel.shouldPlay.onNext(viewModel.videoController.shouldPlay)
                switch result {
                case let .success(user):
                    viewModel.currentUser.onNext(user)
                    print("currentUser dd")
                case .failure:
                    print("DEBUG:: Failed fetching currentUser")
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
        
        input.commentButtonTap
            .withUnretained(self)
            .subscribe(onNext: { viewModel, reels in
                viewModel.navigation.onNext(.comments(reels))
            })
            .disposed(by: self.disposeBag)
               
        input.reelsWillDisplay
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.userUseCase?.currentUser().asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                viewModel.videoController.shouldPlay = true
                viewModel.shouldPlay.onNext(viewModel.videoController.shouldPlay)
                switch result {
                case let .success(user):
                    viewModel.currentUser.onNext(user)
                    print("currentUser dd")
                case .failure:
                    print("DEBUG:: Failed fetching currentUser")
                }
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.heartButtonTap.asObservable(),
            currentUser.asObservable(),
            currentReels.asObserver()
        )
        .observe(on: MainScheduler.asyncInstance)
        .subscribe(onNext: { [weak self] hearts, user, reels in
            print("zz")
            guard let self = self else { return }
            guard let reels = reels, let user = user, let isFilled = try? isHeartFilled.value() else { return }
            if isFilled {
                updateHeartsUseCase?.removeHeart(uid: user.uid, reels: reels)
                isHeartFilled.onNext(false)
                print("false")
            } else {
                updateHeartsUseCase?.addHeart(uid: user.uid, reels: reels)
                isHeartFilled.onNext(true)
                print("true")
            }
        })
        .disposed(by: disposeBag)
        
        input.reelsWillDisplay
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                
                guard let user = try? currentUser.value(), let list = try? reelsList.value() else { return }

                isHeartFilled.onNext(list[indexPath.row].likedList.contains(user.uid))
                print("reelsWillDisplay \(list[indexPath.row].likedList.contains(user.uid))")
            })
            .disposed(by: disposeBag)
    }
}
