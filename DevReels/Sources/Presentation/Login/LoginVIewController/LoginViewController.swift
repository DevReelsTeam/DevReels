//
//  LoginViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class LoginViewController: ViewController{
    
    enum Constant{
        static let padding: CGFloat = 40
    }
    
    struct Layout{
        static let LoginButtonHeight: CGFloat = 50
    }
    
    // MARK: - Properties
    
    private let logoView = LogoView()
    
    private let guideTextLabel = UILabel().then {
        $0.text = "간단한 회원가입 후 이용해주세요"
        $0.textAlignment = .center
    }
    
    private let appleLoginButton = LoginButton().then{
        $0.setTitle("애플 로그인", for: .normal)
        $0.snp.makeConstraints{
            $0.height.equalTo(Layout.LoginButtonHeight)
        }
    }
    
    private let githubLoginButton = LoginButton().then{
        $0.setTitle("깃허브 로그인", for: .normal)
        $0.snp.makeConstraints{
            $0.height.equalTo(Layout.LoginButtonHeight)
        }
    }
    
    override func layout() {
        layoutLogo()
        layoutGuideLabel()
        layoutLoginButton()
    }
    
    // MARK: - Method
    
    private func layoutLogo(){
        view.addSubview(logoView)
        
        logoView.snp.makeConstraints{
            $0.left.right.equalTo(self.view.safeAreaLayoutGuide).inset(Constant.padding)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(100)
        }
    }
    
    private func layoutGuideLabel(){
        view.addSubview(guideTextLabel)
        
        guideTextLabel.snp.makeConstraints{
            $0.top.equalTo(logoView.snp.bottom).offset(Constant.padding)
            $0.left.right.equalTo(logoView)
        }
    }
    
    private func layoutLoginButton(){
        let buttonStackView = createButtonStackView()
        
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints{
            
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constant.padding)
            $0.left.right.equalToSuperview().inset(Constant.padding)
        }
    }
    
    private func createButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [appleLoginButton, githubLoginButton]).then {
            $0.axis = .vertical
            $0.spacing = 10
        }
    }
}
