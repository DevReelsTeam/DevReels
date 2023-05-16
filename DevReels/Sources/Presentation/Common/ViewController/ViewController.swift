//
//  ViewController.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let backButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.setTitleColor(UIColor.systemBackground, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        layout()
        bind()
    }
    
    func layout() {}
    func bind() {}
}
