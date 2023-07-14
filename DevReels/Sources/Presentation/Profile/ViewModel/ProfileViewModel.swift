//
//  ProfileViewModel.swift
//  DevReels
//
//  Created by 현준 on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum ProfileNavigation {
    case editProfile
    case github
    case blog
    case follower
    case following
    case post
    case finish
}

enum ProfileType {
    case current
    case other(User)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.current, .current), (.other, .other):
            return true
        default:
            return false
        }
    }
    
    static func != (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.other, .current), (.current, .other):
            return true
        default:
            return false
        }
    }
}

final class ProfileViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let blogImageViewTap: Observable<Void>
        let githubImageViewTap: Observable<Void>
        let followButtonTap: Observable<Void>
        let editButtonTap: Observable<Void>
        let settingButtonTap: Observable<Void>
    }
    
    struct Output {
        let collectionViewDataSource: Driver<[SectionOfReelsPost]>
    }
    
    let type = BehaviorSubject<ProfileType>(value: .current)
    private let currentUser = BehaviorSubject<User?>(value: nil)
    private let follower = BehaviorSubject<[User]>(value: [])
    private let following = BehaviorSubject<[User]>(value: [])
    private let reels = BehaviorSubject<[Reels]>(value: [])
    private let collectionViewDataSource = BehaviorSubject<[SectionOfReelsPost]>(value: [])
    
    var userUseCase: UserUseCaseProtocol?
    var profileUseCase: ProfileUseCaseProtocol?
    var reelsUseCase: ReelsUseCaseProtocol?
    var hyperlinkUseCase: HyperLinkUseCaseProtocol?
    let disposeBag = DisposeBag()

    let navigation = PublishSubject<ProfileNavigation>()
    
    func transform(input: Input) -> Output {
       
        Observable.merge(
            Observable.just(()),
            input.viewWillAppear.skip(1)
        )
        .withLatestFrom(type)
        .filter { $0 == ProfileType.current }
        .withUnretained(self)
        .flatMap {
            $0.0.userUseCase?.currentUser().asResult() ?? .empty()
        }
        .withUnretained(self)
        .subscribe(onNext: { viewModel, result in
            switch result {
            case .success(let user):
                viewModel.currentUser.onNext(user)
                
            case .failure:
                let failureUser = User(
                    identifier: "",
                    profileImageURLString: "",
                    nickName: "홍길동",
                    githubURL: "https://github.com/",
                    blogURL: "https://www.naver.com/",
                    introduce: "비 로그인 상태입니다.",
                    uid: "")
                viewModel.currentUser.onNext(failureUser)
            }
        })
        .disposed(by: disposeBag)
        
        
        input.viewWillAppear
            .withLatestFrom(type)
            .compactMap { type in
                switch type {
                case .current:
                    return nil
                case let .other(user):
                    return user
                }
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, user in
                viewModel.currentUser.onNext(user)
            })
            .disposed(by: disposeBag)
        
        type
            .filter { $0 != .current }
            .subscribe(onNext: { _ in
                print("\n\n\n\n\n")
                print("aaaa")
                print("\n\n\n\n\n")
            })
        
        
        currentUser
            .withUnretained(self)
            .flatMap { $0.0.profileUseCase?.follower(uid: $0.1?.uid ?? " ").asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let users):
                    viewModel.follower.onNext(users)
                default:
                    viewModel.follower.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        currentUser
            .withUnretained(self)
            .flatMap { $0.0.profileUseCase?.following(uid: $0.1?.uid ?? " ").asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let users):
                    viewModel.following.onNext(users)
                default:
                    viewModel.following.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
        currentUser
            .withUnretained(self)
            .flatMap { $0.0.reelsUseCase?.fetch(uid: $0.1?.uid ?? " ").asResult() ?? .empty() }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let reels):
                    viewModel.reels.onNext(reels)
                default:
                    viewModel.reels.onNext([])
                }
            })
            .disposed(by: disposeBag)
        
//        let aa = reelsUseCase
//
//
//        aa?.fetch(uid: "tempUID")
//            .subscribe(onNext: {
//                print("\n\n\n\n\n")
//                print($0)
//                print("\n\n\n\n\n")
//            })
        
        transformCollectionViewDataSource(input: input)
        transformTapEvent(input: input)
    
        return Output(
            collectionViewDataSource: collectionViewDataSource.asDriver(onErrorJustReturn: [])
        )
    }
    
    private func transformCollectionViewDataSource(input: ProfileViewModel.Input) {
        Observable.combineLatest(
            currentUser.compactMap { $0 }.asObservable(),
            follower,
            following,
            reels,
            type
        )
        .map { user, follower, following, reels, type -> [SectionOfReelsPost] in
            
            let header = Header(
                profileImageURLString: user.profileImageURLString,
                userName: user.nickName,
                introduce:  "<" + " \(user.introduce) " + "/>",
                githubURL: user.githubURL,
                blogURL: user.blogURL,
                postCount: "\(reels.count)",
                followerCount: "\(follower.count)",
                followingCount: "\(following.count)",
                isMyProfile: type == .current ? true : false
            )
            
            return [
                SectionOfReelsPost(
                    header: header,
                    items: reels
                )
            ]
        }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                viewModel.collectionViewDataSource.onNext(result)
            })
            .disposed(by: disposeBag)
    }
    
    private func transformTapEvent(input: ProfileViewModel.Input) {
        input.blogImageViewTap
            .withLatestFrom(currentUser.compactMap { $0 })
            .withUnretained(self)
            .subscribe(onNext: { viewModel, user in
                viewModel.hyperlinkUseCase?.openSafari(urlString: user.blogURL)
            })
            .disposed(by: disposeBag)
        
        input.githubImageViewTap
            .withLatestFrom(currentUser.compactMap { $0 })
            .withUnretained(self)
            .subscribe(onNext: { viewModel, user in
                viewModel.hyperlinkUseCase?.openSafari(urlString: user.githubURL)
            })
            .disposed(by: disposeBag)
        
        input.followButtonTap
            .subscribe(onNext: { _ in
                print("\n\n\n")
                print("follow")
                print("\n\n\n")
            })
            .disposed(by: disposeBag)
        
        input.editButtonTap
            .subscribe(onNext: { _ in
                print("\n\n\n")
                print("edit")
                print("\n\n\n")
            })
            .disposed(by: disposeBag)
        
        input.settingButtonTap
            .subscribe(onNext: { _ in
            print("\n\n\n")
            print("setting")
            print("\n\n\n")
        })
        .disposed(by: disposeBag)
    }
}
