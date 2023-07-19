//
//  CreateUserViewModel.swift
//  DevReels
//
//  Created by HoJun on 2023/07/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum EditProfileNavigation {
    case finish
    case back
}

final class EditProfileViewModel: ViewModel {
    
    enum EditType {
        case create
        case edit
    }
    
    struct Input {
        let name: Observable<String>
        let introduce: Observable<String>
        let profileImage: Observable<UIImage>
        let urlValidation: Observable<Bool>
        let githubUrlString: Observable<String>
        let blogUrlString: Observable<String>
        let completeButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let originName: Driver<String>
        let originIntroduce: Driver<String>
        let originProfileImage: Driver<UIImage>
        let inputValidation: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    var editProfileUseCase: EditProfileUseCaseProtocol?
    let navigation = PublishSubject<EditProfileNavigation>()
    let type = BehaviorSubject<EditType>(value: .edit)
    private let user = BehaviorSubject<User?>(value: nil)
    private let name = BehaviorSubject<String>(value: "")
    private let introduce = BehaviorSubject<String>(value: "")
    private let image = BehaviorSubject<UIImage>(value: UIImage())
    private let inputValidation = BehaviorSubject<Bool>(value: false)
    private let alert = PublishSubject<Alert>()
    
    func transform(input: Input) -> Output {
        bindUser(input: input)
        bindScene(input: input)
        
        return Output()
    }
    
    private func bindUser(input: Input) {
        type
            .filter { $0 == .edit }
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.editProfileUseCase?.loadProfile().asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe { viewModel, result in
                switch result {
                case .success(let user):
                    viewModel.user.onNext(user)
                case .failure:
                    // TODO: 유저 정보 가져오기 실패 처리
                    break
                }
            }
            .disposed(by: disposeBag)
        
        Observable.merge(user.compactMap { $0?.nickName }, input.name)
            .bind(to: name)
            .disposed(by: disposeBag)
    
        Observable.merge(user.compactMap { $0?.introduce }, input.introduce)
            .bind(to: introduce)
            .disposed(by: disposeBag)
        

    }
    
    private func bindScene(input: Input) {
        
    }
}
