//
//  EditProfileUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct EditProfileUseCase: EditProfileUseCaseProtocol {

    var userRepository: UserRepositoryProtocol?
    
    func loadProfile() -> Observable<User> {
        return userRepository?.currentUser() ?? .empty()
    }
    
    func createProfile(user: User) -> Observable<Void> {
        return userRepository?.create(user: user) ?? .empty()
    }
    
    func editProfile(user: User) -> Observable<Void> {
        return userRepository?.update(user: user) ?? .empty()
    }
}
