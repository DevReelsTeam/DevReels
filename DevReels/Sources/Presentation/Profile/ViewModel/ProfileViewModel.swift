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
}

final class ProfileViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    let type = BehaviorSubject<ProfileType>(value: .current)
    private let currentUser = BehaviorSubject<User?>(value: nil)
    private let follower = BehaviorSubject<[User]>(value: [])
    private let following = BehaviorSubject<[User]>(value: [])
    private let collectionViewDataSource = BehaviorSubject<[SectionOfReelsPost]>(value:[])
    
    let userUseCase = DIContainer.shared.container.resolve(UserUseCaseProtocol.self)
    let profileUseCase = DIContainer.shared.container.resolve(ProfileUseCaseProtocol.self)
    var disposeBag = DisposeBag()
    
    struct Output {
        let collectionViewDataSource: Driver<[SectionOfReelsPost]>
        let currentUserName: Driver<String>
        let currentUserIntroduce: Driver<String>
        let currentUserProfileImageURLString: Observable<String>
        let currentUserGithubURL: Driver<String>
        let currentUserBlogURL: Driver<String>
    }
    
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
                    blogURL: "www.naver.com",
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

        
        
        Observable.combineLatest(
            currentUser.compactMap { $0 },
            follower,
            following
        )
        .map { user, follower, following  -> [SectionOfReelsPost] in
            let header = Header(
                profileImageURLString: user.profileImageURLString,
                userName: user.nickName,
                introduce: user.introduce,
                githubURL: user.githubURL,
                blogURL: user.blogURL,
                postCount: "0",
                followerCount: "\(follower.count)",
                followingCount: "\(following.count)")
            return [
                SectionOfReelsPost(
                    header: header,
                    items: [
                        Reels(id: "", title: "", videoDescription: ""),
                        Reels(id: "", title: "", videoDescription: "")
                    ]
                )
            ]
        }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                viewModel.collectionViewDataSource.onNext(result)
            })
            .disposed(by: disposeBag)
        
        let aa = ProfileUseCase()
        
        
//        aa.follower(uid: "asdf")
//            .subscribe(onNext: {
//                print("\n\n\n\n\n")
//                print($0)
//                print("\n\n\n\n\n")
//            })

        return Output(
            collectionViewDataSource: collectionViewDataSource.asDriver(onErrorJustReturn: []),
            currentUserName: currentUser.compactMap { $0?.nickName }.asDriver(onErrorJustReturn: "홍길동"),
            currentUserIntroduce: currentUser.compactMap { $0?.introduce }.asDriver(onErrorJustReturn: "비 로그인 상태입니다."),
            currentUserProfileImageURLString: currentUser.compactMap { $0?.profileImageURLString }.asObservable(),
            currentUserGithubURL: currentUser.compactMap { $0?.githubURL }.asDriver(onErrorJustReturn: "https://github.com/"),
            currentUserBlogURL: currentUser.compactMap { $0?.githubURL }.asDriver(onErrorJustReturn: "www.naver.com")
        )
    }
}
