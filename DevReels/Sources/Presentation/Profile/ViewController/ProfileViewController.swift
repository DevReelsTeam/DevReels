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
    
    private var userProfileImageView: UIImageView = {
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
