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

class ProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        let editButtonTapped = PublishRelay<Void>()
        let githubButtonTapped = PublishRelay<Void>()
        let blogButtonTapped = PublishRelay<Void>()
        let followerButtonTapped = PublishRelay<Void>()
        let followingButtonTapped = PublishRelay<Void>()
        let postTapped = PublishRelay<Post.ID>()
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
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    let input = Input()
    lazy var output = transform(input: input)
}
