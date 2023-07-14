//
//  ProfileUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/12.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct ProfileUseCase: ProfileUseCaseProtocol {
    var userRepository = DIContainer.shared.container.resolve(UserRepositoryProtocol.self)
    
    func follower(uid: String) -> Observable<[User]> {
        return userRepository?.fetchFollower(uid: uid) ?? .empty()
    }
    
    func following(uid: String) -> Observable<[User]> {
        return userRepository?.fetchFollowing(uid: uid) ?? .empty()
    }
}
