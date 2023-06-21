//
//  AuthRepository.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

enum AuthError: Error {
    case signInError
}

struct AuthRepository: AuthRepositoryProtocol {
    // API 사용
    
    var authService: AuthServiceProtocol?
    private let disposeBag = DisposeBag()
    
    func signIn(with credential: OAuthCredential) -> Observable<Authorization> {
        let reqeust = OAuthAuthorizationRequestDTO(idToken: credential.idToken ?? "")
        
        return authService?.login(reqeust)
            .map { $0.toDomain() } ?? .empty()
    }
    
    // SDK 사용
//    func signIn(with credential: OAuthCredential) -> Observable<String> {
//        return Observable.create { emitter in
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    emitter.onError(error)
//                    return
//                }
//
//                guard let uid = authResult?.user.uid else {
//                    emitter.onError(AuthError.signInError)
//                    return
//                }
//
//                emitter.onNext(uid)
//                emitter.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
}
