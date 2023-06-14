//
//  UrlTextField.swift
//  DevReels
//
//  Created by HoJun on 2023/06/10.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class UrlTextField: UIView {
    
    // MARK: Public
    
    var validation: TextField.Validation = .none {
        didSet {
            textField.validation = validation
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
            )
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
        
    // MARK: Private
    
    fileprivate let textField = TextField()
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .left
    }
    
    private let validUrlLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .systemRed
        $0.textAlignment = .right
    }
    
    private var disposable: Disposable?
    
    // MARK: Inits
    
    init(isSecure: Bool = false) {
        super.init(frame: .zero)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setHeight(_ value: CGFloat) {
        textField.snp.makeConstraints {
            $0.height.equalTo(value)
        }
    }
    
    private func bind() {
        disposable = textField.rx.text
            .subscribe { [weak self] _ in
                self?.update()
            }
    }
    
    private func update() {
        if let urlString = textField.text,
           let url = URL(string: urlString) {
            validUrlLabel.text = UIApplication.shared.canOpenURL(url) ? nil : "올바르지 않은 URL 형식입니다."
        } else {
            validUrlLabel.text = nil
        }
    }
    
    private func layout() {
        layoutStackView()
        layoutTextField()
    }
    
    private func layoutStackView() {
        [titleLabel, validUrlLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(4)
            make.height.equalTo(30.0)
        }
    }
    
    private func layoutTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(8)
        }
    }
}

extension Reactive where Base: UrlTextField {
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    
    var isValidURL: Observable<Bool> {
        return base.textField.rx.text
            .map { urlString in
                guard let urlString = urlString else { return false }
                guard let url = URL(string: urlString) else { return false }
                return UIApplication.shared.canOpenURL(url)
            }
            .share(replay: 1)
    }
}
