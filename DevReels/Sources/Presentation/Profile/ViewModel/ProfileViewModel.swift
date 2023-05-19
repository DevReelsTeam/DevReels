//
//  ProfileViewModel.swift
//  DevReels
//
//  Created by Sh Hong on 2023/05/14.
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

struct Post {
    typealias Identifier = Int
    
    let id: Int
    let image: UIImage
}

struct Count {
    var count: Int
    
    init?(cnt: Int) {
        guard cnt >= 0 else { return nil }
        self.count = cnt
    }
}

final class ProfileViewModel: ViewModel {
    
    var disposeBag: DisposeBag = .init()
    
    struct Input {
        let editButtonTapped = PublishRelay<Void>()
        let githubButtonTapped = PublishRelay<Void>()
        let blogButtonTapped = PublishRelay<Void>()
        let followerButtonTapped = PublishRelay<Void>()
        let followingButtonTapped = PublishRelay<Void>()
        let postTapped = PublishRelay<Post.Identifier>()
    }
    
    struct Output {
//        let userImage: Driver<UIImage>
//        let userName: Driver<String>
//        let userIntroduction: Driver<String>
//        let userGithubURL: Driver<URL>
//        let userBlogURL: Driver<URL>
//        let postCount: Driver<Count>
//        let followerCount: Driver<Count>
//        let followingCount: Driver<Count>
//        let posts: Driver<[Post]>
    }
    
    let navigation = PublishSubject<ProfileNavigation>()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
    let input = Input()
    lazy var output = transform(input: input)
}
