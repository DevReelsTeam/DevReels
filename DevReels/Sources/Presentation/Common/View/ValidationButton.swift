//
//  ValidationButton.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit

final class ValidationButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureFont()
        configureRadius()
        configureEnableColor()
        configureDisableColor()
    }
    
    private func configureFont() {
        titleLabel?.font = .boldSystemFont(ofSize: 20)
    }
    
    private func configureRadius() {
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    private func configureEnableColor() {
        setBackgroundColor(.darkGray, for: .normal)
        setTitleColor(UIColor.orange, for: .normal)
    }
    
    private func configureDisableColor() {
        setBackgroundColor(.lightGray, for: .disabled)
        setTitleColor(UIColor.white, for: .disabled)
    }
}
