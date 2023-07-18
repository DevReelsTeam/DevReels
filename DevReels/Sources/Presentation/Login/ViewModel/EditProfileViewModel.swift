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

final class EditProfileViewModel: ViewModel {

    
    struct Input {
        let name: Observable<String>
        let introduce: Observable<String>
        let profileImage: Observable<UIImage>
        let completeButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
//    let input = EditProfileViewModel.Input(
//        name: nameTextfield.rx.text.orEmpty.asObservable(),
//        introduce: introuceCountTextView.rx.text.orEmpty.asObservable(),
//        selectedProfileImage: selectedProfileImage.asObservable(),
//        completeButtonTapped: completeButton.rx.tap
//            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
//        backButtonTapped: backButton.rx.tap
//            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
//    )
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
