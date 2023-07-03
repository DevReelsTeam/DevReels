//
//  UserRepository.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UserRepository: UserRepositoryProtocol {
    var userDataSource: UserDataSourceProtocol?
    
    func create(uid: String, email: String) -> Observable<Void> {
        let request = UserRequestDTO(uid: uid, email: email)
        return userDataSource?.create(request: request) ?? .empty()
    }
    
    func fetch(uid: String) -> Observable<User> {
        return userDataSource?.read(uid: uid)
            .map { $0.toDomain() } ?? .empty()
    }
}
