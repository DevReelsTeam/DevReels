//
//  CountTextView.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class CountTextView: UIView {
    
    // MARK: Public
    
    var placeholder: String? {
        didSet {
            textView.placeholder = placeholder
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var maxCount: Int = -1 {
        didSet {
            update()
        }
    }
    
    // MARK: Private
    
    fileprivate let textView = TextView()
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .left
    }
    
    private let countLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .right
    }
    
    private var disposable: Disposable?
    
    // MARK: Inits
    
    init() {
        super.init(frame: .zero)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func bind() {
        disposable = textView.rx.text
            .subscribe { [weak self] _ in
                self?.update()
            }
    }
    
    private func update() {
        let maxCount = maxCount < 0 ? Int.max : maxCount
        if let str = textView.text?.prefix(maxCount) {
            textView.text = String(str)
        }
        countLabel.isHidden = maxCount == Int.max ? true : false
        countLabel.text = "\(textView.text?.count ?? 0)/\(maxCount)"
    }
    
    private func layout() {
        layoutStackView()
        layoutTextView()
    }
    
    private func layoutStackView() {
        [titleLabel, countLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
            make.height.equalTo(30.0)
        }
    }
    
    private func layoutTextView() {
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(8)
        }
    }
}

extension Reactive where Base: CountTextView {
    
    var text: ControlProperty<String?> {
        return base.textView.rx.text
    }
}
