//
//  TextView.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit

class TextView: UITextView {
    
    // MARK: Public
    
    var placeholder: String? {
        didSet {
            label.text = placeholder
        }
    }
    
    // MARK: Private
    
    private var label = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private var disposeBag = DisposeBag()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        setup()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setup() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemGray.cgColor
        textContainerInset = .init(top: 16, left: 16, bottom: 16, right: 16)
        textContainer.lineFragmentPadding = 0
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        setupFont()
    }
    
    private func setupFont() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
        ]
        typingAttributes = attributes
    }
    
    private func layout() {
        self.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(50)
        }
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
        self.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: label.rx.isHidden )
            .disposed(by: disposeBag)
    }
}
