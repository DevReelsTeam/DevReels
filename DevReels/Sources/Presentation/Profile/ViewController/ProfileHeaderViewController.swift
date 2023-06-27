//
//  ProfileHeaderViewController.swift
//  DevReels
//
//  Created by Sh Hong on 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfileHeaderViewControllable: UIViewController {
}

final class ProfileHeaderViewController: UIViewController {
    
    private enum Metrics {
        enum UserImage {
            static let height = 100
            static let topMargin = 38
        }
        
        enum UserName {
            static let topMargin = 18
        }
        
        enum UserIntroduction {
            static let topMargin = 4
        }
        
        enum PostLabel {
            static let rightMargin = 14
        }
        
        enum FollowerLabel {
            static let topMargin = 18
        }
        
        enum FollowingLabel {
            static let leftMargin = 14
        }
        
        enum FollowerButton {
            static let horizontalMargin = 16
            static let topMargin = 37
            static let height = 37
        }
    }
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = CGFloat(Metrics.UserImage.height / 2)
        return imageView
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        label.text = "김코드"
        return label
    }()
    
    private let userIntroduction: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 14,
            weight: .semibold
        )
        label.text = "< 안녕하세요🔥 성장하는 개발자입니다👩‍💻 />"
        return label
    }()
    
    private let postCountLabel = NumberInformationLabel(title: "게시물", count: 100)
    
    private let followerCountLabel = NumberInformationLabel(title: "팔로워", count: 100)
    
    private let followingCountLabel = NumberInformationLabel(title: "팔로잉", count: 100)
    
    private let followerButton: UIButton = {
        let button = UIButton()
        button.setTitle("< Follow >", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.backgroundColor = .init(red: 244, green: 113, blue: 0, alpha: 1)
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    // MARK: - Layout
    private func layout() {
        self.view.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                .inset(Metrics.UserImage.topMargin)
            make.height.equalTo(Metrics.UserImage.height)
        }
        
        self.view.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(Metrics.UserName.topMargin)
            make.centerX.equalTo(userImage)
        }
        
        self.view.addSubview(userIntroduction)
        userIntroduction.snp.makeConstraints { make in
            make.top.equalTo(userName.snp.bottom).offset(Metrics.UserIntroduction.topMargin)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(followerCountLabel)
        followerCountLabel.snp.makeConstraints { make in
            make.centerX.equalTo(userImage)
            make.top.equalTo(userIntroduction.snp.bottom).offset(Metrics.FollowerLabel.topMargin)
        }
        
        self.view.addSubview(postCountLabel)
        postCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(followerCountLabel)
            make.right.equalTo(followerCountLabel.snp.left).offset(Metrics.PostLabel.rightMargin)
        }
        
        self.view.addSubview(followingCountLabel)
        followingCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(followerCountLabel)
            make.left.equalTo(followerCountLabel.snp.right).offset(Metrics.FollowingLabel.leftMargin)
        }
        
        self.view.addSubview(followerButton)
        followerButton.snp.makeConstraints { make in
            make.top.equalTo(followerCountLabel.snp.bottom).offset(Metrics.FollowerButton.topMargin)
            make.left.right.equalToSuperview().inset(Metrics.FollowerButton.horizontalMargin)
            make.height.equalTo(Metrics.FollowerButton.height)
        }
    }
}
