//
//  LoginViewModel.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

enum LoginNavigation{
    case finish
}

final class LoginViewModel: ViewModel{
    
    struct Input{
        let appleCredential: Observable<OAuthCredential>
        let githupLoginButtonTap: Observable<Void>
    }
    
    struct Output{
    }
    
    let navigation = PublishSubject<LoginNavigation>()
    var loginUseCase: LoginUseCaseProtocol?
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        input.appleCredential
            .withUnretained(self)
            .flatMap { viewModel, credential in
                viewModel.loginUseCase?.singIn(with: credential) ?? .empty()
            }
            .withUnretained(self)
            .subscribe { viewModel, result in
                switch result {
                case .success:
                    print(result)
                    viewModel.navigation.onNext(.finish)
                case .failure:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
