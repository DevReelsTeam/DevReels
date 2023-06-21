//
//  LoginUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/23.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth



struct LoginUseCase: LoginUseCaseProtocol {
    
    // MARK: - Properties
    
    var authRepository: AuthRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    // MARK: - Method
    
    func singIn(with credential: OAuthCredential) -> Observable<Void> {
        return (authRepository?.signIn(with: credential) ?? .empty())
            .map {
                tokenRepository?.save($0)
            }
            .map { _ in () }
    }
}
