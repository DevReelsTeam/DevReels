//
//  LogoView.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class LogoView: UIView{
    
    private let titleLabel = UILabel().then {
        $0.text = "DevReels"
        $0.textAlignment = .center
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "개발자의 릴스"
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setupTitle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        addSubViews([titleLabel, subtitleLabel])
        
        titleLabel.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints{
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupTitle(){
        let subtitlesize = subtitleLabel.font.pointSize
        titleLabel.font = .systemFont(ofSize: subtitlesize + 30)
    }
}
