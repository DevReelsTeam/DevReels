//
//  UserRepositoryProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func create(uid: String, email: String) -> Observable<Void>
    func exist() -> Observable<Bool>
    func fetch(uid: String) -> Observable<User>
    func currentUser() -> Observable<User>
    func fetchFollower(uid: String) -> Observable<[User]>
    func fetchFollowing(uid: String) -> Observable<[User]>
}
