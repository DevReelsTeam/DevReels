//
//  TextField.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

class TextField: UITextField {
    
    enum Validation {
        case none
        case valid
        case invalid
        
        var color: UIColor {
            switch self {
            case .none:
                return UIColor.systemGray
            case .valid:
                return UIColor.systemGreen
            case .invalid:
                return UIColor.systemRed
            }
        }
    }
    
    // MARK: Public
    
    final var validation: Validation = .none {
        didSet {
            layer.borderColor = validation.color.cgColor
        }
    }
    
    // MARK: Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setup() {
        backgroundColor = .secondarySystemBackground
        font = UIFont.systemFont(ofSize: 16)
        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.borderColor = UIColor.clear.cgColor
        leftViewMode = .always
        rightViewMode = .always
        leftView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
        rightView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
    }
    
    private func layout() {
        snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(Layout.minimumTextFieldHeight)
        }
    }
}
