//
//  NumberInformationLabel.swift
//  DevReels
//
//  Created by Sh Hong on 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

class NumberInformationLabel: UIStackView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14,
            weight: .semibold
        )
        return label
    }()
    
    init(title: String, count: Int) {
        super.init(frame: .zero)
        
        configure()
        self.titleLabel.text = title
        self.countLabel.text = "\(count)"
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        self.axis = .horizontal
        self.addArrangedSubview([
            titleLabel,
            countLabel
        ])
        self.alignment = .center
        self.spacing = 4
    }
}
