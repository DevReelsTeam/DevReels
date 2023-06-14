//
//  ProfileHeaderViewController.swift
//  DevReels
//
//  Created by Sh Hong on 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

final class ProfileHeaderViewController: UIViewController {
    
    private enum Metrics {
        
    }
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
