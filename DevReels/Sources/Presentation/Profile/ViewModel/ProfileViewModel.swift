//
//  ProfileViewModel.swift
//  DevReels
//
//  Created by Sh Hong on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    
    var disposeBag: RxSwift.DisposeBag = .init()
    
    struct Input {
        
    }
    
    struct Output {

    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
    let input = Input()
    lazy var output = transform(input: input)
}
