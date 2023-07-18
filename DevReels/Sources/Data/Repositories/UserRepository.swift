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
    
    enum UserRepositoryError: Error {
        case noUserInfo
    }
    
    var userDataSource: UserDataSourceProtocol?
    var keyChainManager: KeychainManagerProtocol?
    
    func create(uid: String, email: String) -> Observable<Void> {
        let request = UserRequestDTO(uid: uid, email: email)
        return userDataSource?.create(request: request) ?? .empty()
    }
    
    func fetch(uid: String) -> Observable<User> {
        return userDataSource?.read(uid: uid)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func currentUser() -> Observable<User> {
        guard let data = keyChainManager?.load(key: .authorization),
              let authorization = try? JSONDecoder().decode(Authorization.self, from: data) else {
            return Observable.error(UserRepositoryError.noUserInfo)
        }
        
        return fetch(uid: authorization.localId)
    }
    
    func fetchFollower(uid: String) -> Observable<[User]> {
        return userDataSource?.fetchFollower(uid: uid)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func fetchFollowing(uid: String) -> Observable<[User]> {
        return userDataSource?.fetchFollowing(uid: uid)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func follow(targetUser: User, currentUser: User) -> Observable<Void> {
        return userDataSource?.follow(targetUserData: targetUser, myUserData: currentUser) ?? .empty()
    }
    
    func unfollow(targetUser: User, currentUser: User) -> Observable<Void> {
        return userDataSource?.unfollow(targetUserData: targetUser, myUserData: currentUser) ?? .empty()
    }
    
    func update(user: User) {
        userDataSource?.update(user: user)
    }
}
