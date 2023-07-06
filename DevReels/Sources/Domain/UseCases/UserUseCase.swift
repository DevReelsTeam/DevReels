//
//  UserUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/06.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UserUseCase {
    
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
//    func myProfileImage() -> Observable<UIImage> {
//        userRepository?.currentUser()
//            .flatMap { }
//    }
}
