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
    private let collectionViewDataSource = BehaviorSubject<[SectionOfReelsPost]>(value:[])
    
    private let userUseCase = UserUseCase()
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
            $0.0.userUseCase.currentUser().asResult()
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
        
        Observable.combineLatest(
            currentUser.compactMap { $0 },
            Observable.just(())
        )
        .map { user, _  -> [SectionOfReelsPost] in
            let header = Header(
                profileImageURLString: user.profileImageURLString,
                userName: user.nickName,
                introduce: user.introduce,
                githubURL: user.githubURL,
                blogURL: user.blogURL,
                postCount: "0",
                followerCount: "0",
                followingCount: "0")
            
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
        
//        let aa = UserDataSource()
        
        
//        aa.fetchFollowing(uid: "QoTCI64dz7bTOv6dfVaXCCssRrp2")
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
