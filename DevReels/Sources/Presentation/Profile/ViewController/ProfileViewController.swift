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
    var viewModel: ProfileViewModel
    
    let profileHeader: ProfileHeaderViewController
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = ProfileViewModel()
        self.profileHeader = ProfileHeaderViewController()
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constants
    private enum Metric {
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
    
    // MARK: - Components
    
    private let postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
        let itemSize = (UIScreen.main.bounds.width - 34) / 2.0
        
        layout.itemSize = CGSize(
            width: itemSize,
            height: itemSize
        )
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.register(ReelsCollectionCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return collectionView
    }()
    
    // MARK: Bind View Model
    func bindViewModel() {
        viewModel.output.posts
            .drive(postCollectionView.rx.items(cellIdentifier: ReelsCollectionCell.defaultReuseIdentifier, cellType: ReelsCollectionCell.self)) { _, _, cell in
                cell.layer.cornerRadius = 6
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }

    // MARK: - Layout
    private func layout() {
        self.view.addSubview(profileHeader.view)
        profileHeader.view.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        self.view.addSubview(postCollectionView)
        postCollectionView.snp.makeConstraints { make in
            postCollectionView.snp.makeConstraints { make in
                make.top.equalTo(profileHeader.view.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
        }
    }
}
