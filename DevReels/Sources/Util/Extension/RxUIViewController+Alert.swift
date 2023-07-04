//
//  RxUIViewController+Alert.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var presentAlert: Binder<Alert> {
        return Binder(base) { base, alert in
            let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alertController.addAction(okAction)
            base.present(alertController, animated: true)
        }
    }
}
