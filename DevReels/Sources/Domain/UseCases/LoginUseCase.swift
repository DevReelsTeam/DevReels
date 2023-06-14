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

enum AuthResult{
    case success
    case failure
}

struct LoginUseCase: LoginUseCaseProtocol {
    
    // MARK: - Properties
    
    var authRepository: AuthRepositoryProtocol?
    
    // MARK: - Method
    
    func singIn(with credential: OAuthCredential) -> Observable<AuthResult>{
        return authRepository?.signIn(with: credential)
            .map{
                if $0 != ""{
                    return AuthResult.success
                } else {
                    return AuthResult.failure
                }
            } ?? .empty()
    }
}
