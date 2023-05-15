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

class ProfileViewController: UIViewController {
    
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
    
    private let userProfileEditButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let userIntroduction: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let githubButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let blogButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        let itemSize = UIScreen.main.bounds.width / 3.0
        
        layout.itemSize = CGSize(
            width: itemSize,
            height: itemSize
        )
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

//        collectionView.register(PostCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        
        return collectionView
    }()
    
    // MARK: Bind View Model
    func bindViewModel() {
        
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }

    // MARK: - Layout
    private func layout() {
        
    }
}
