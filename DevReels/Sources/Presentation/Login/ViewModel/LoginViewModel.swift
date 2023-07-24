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
    case createProfile
    case finish
}

final class LoginViewModel: ViewModel {
    
    struct Input {
        let appleCredential: Observable<OAuthCredential>
        let righButtonTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    let navigation = PublishSubject<LoginNavigation>()
    var loginUseCase: LoginUseCaseProtocol?
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // MARK: - Bind
        input.appleCredential
            .withUnretained(self)
            .flatMap { viewModel, credential in
                viewModel.loginUseCase?.singIn(with: credential).asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe { viewModel, result in
                switch result {
                case .success:
                    viewModel.loginUseCase?.exist()
                        .subscribe(onNext: { found in
                            if found {
                                viewModel.navigation.onNext(.finish)
                            } else {
                                viewModel.navigation.onNext(.createProfile)
                            }
                        })
                case .failure:
                    // MARK: - 로그인 실패 알럿 띄워야함.
                    break
                }
            }
            .disposed(by: disposeBag)
        
        input.righButtonTap
            .subscribe(onNext: { [weak self] in
                self?.navigation.onNext(.finish)
            })
            .disposed(by: DisposeBag())

        
        return Output()
    }
}
