//
//  ProfileViewController.swift
//  DevReels
//
//  Created by Sh Hong on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, ViewModelBindable {
    
    var disposeBag: DisposeBag = .init()
    var viewModel: ProfileViewModel!
    
    private enum Metric {
        enum ProfileImage {
            static let height = 0
            static let leftMargin = 0
            static let topMargin = 0
            static let rightMargin = 0
            static let bottomMargin = 0
        }
        
        enum UserInformation {
            static let leftMargin = 0
            static let topMargin = 0
            static let rightMargin = 0
            static let bottomMargin = 0
        }
        
        enum UserURL {
            static let leftMargin = 0
            static let topMargin = 0
            static let rightMargin = 0
            static let bottomMargin = 0
        }
        
        enum PostFollowInfo {
            static let leftMargin = 0
            static let topMargin = 0
            static let rightMargin = 0
            static let bottomMargin = 0
        }
        
        enum PostCollectionView {
            static let leftMargin = 0
            static let topMargin = 0
            static let rightMargin = 0
            static let bottomMargin = 0
        }
    }
    
    private enum Constant {
        static let headerTitle: String = "마이페이지"
    }
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var userProfileEditButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var userName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private var userIntroduction: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var githubButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var blogButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private var feedCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        
        return collectionView
    }()
    
    func bindViewModel() {
        
    }
}
