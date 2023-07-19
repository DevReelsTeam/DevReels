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
        case userNotFound
    }
    
    var userDataSource: UserDataSourceProtocol?
    var keyChainManager: KeychainManagerProtocol?
    
    func fetch(uid: String) -> Observable<User> {
        return userDataSource?.read(uid: uid)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func currentUser() -> Observable<User> {
        guard let data = keyChainManager?.load(key: .authorization),
              let authorization = try? JSONDecoder().decode(Authorization.self, from: data) else {
            return Observable.error(UserRepositoryError.userNotFound)
        }
        
        return fetch(uid: authorization.localId)
    }
    
    func exist() -> Observable<Bool> {
        guard let data = keyChainManager?.load(key: .authorization),
              let authorization = try? JSONDecoder().decode(Authorization.self, from: data) else {
            return Observable.error(UserRepositoryError.userNotFound)
        }
        
        return userDataSource?.exist(uid: authorization.localId) ?? .empty()
    }
    
    func create(user: User) -> Observable<Void> {
        let request = UserRequestDTO(user: user)
        return userDataSource?.create(request: request) ?? .empty()
    }
    
    func update(user: User) -> Observable<Void> {
        let request = UserRequestDTO(user: user)
        return userDataSource?.update(request: request) ?? .empty()
    }
    
    func fetchFollower(uid: String) -> Observable<[User]> {
        return userDataSource?.fetchFollower(uid: uid)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func fetchFollowing(uid: String) -> Observable<[User]> {
        return userDataSource?.fetchFollowing(uid: uid)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
}
