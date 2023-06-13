//
//  RxUIViewController+LifeCycle.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/17.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/*
 RxSwift를 통한 메서드 구독 - https://clamp-coding.tistory.com/458
 */

extension Reactive where Base: UIViewController{
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false}
        return ControlEvent(events: source)
    }
}
