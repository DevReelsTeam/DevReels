//
//  LoginCoordinator.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

// finish : 화면 전환 완료
// Back : 뒤로가기.

enum LoginCoordinatorResult {
    case finish
    case back
}



final class LoginCoordinator: BaseCoordinator<LoginCoordinatorResult>{
    
    let finish = PublishSubject<LoginCoordinatorResult>()
    
    override func start() -> Observable<LoginCoordinatorResult> {
        showLogin()
        
        return finish
    }
    
    func showLogin(){
        
    }
}
