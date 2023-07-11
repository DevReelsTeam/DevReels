//
//  ProfileViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct ReelsSection {
    let header: String
    var items: [String]
}

extension ReelsSection: AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: ReelsSection, items: [String]) {
        self = original
        self.items = items
    }
}

final class ProfileViewController: ViewController {
    
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<ReelsSection>(configureCell: { (datasource, collectionView, indexPath, item) in
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReelsCollectionCell.identifier,
            for: indexPath
        ) as? ReelsCollectionCell else { return UICollectionViewCell() }
        
//        cell.commentCount.text = "\(item)"
        return cell
        
    }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
       
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.identifier,
            for: indexPath
        ) as? ProfileHeaderView else { return UICollectionReusableView() }
        
        return header
    })
    
    private let mockSession = [ReelsSection(header: "첫번째 섹션", items: ["김치", "삼계탕", "불고기","김치", "삼계탕", "불고기","김치", "삼계탕", "불고기"])]
    
    // MARK: - Components
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = CGFloat(12)
        layout.minimumInteritemSpacing = CGFloat(12)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.register(ReelsCollectionCell.self, forCellWithReuseIdentifier: ReelsCollectionCell.identifier)
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
                                
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 20)
        return collectionView
    }()
    
    var viewModel: ProfileViewModel
    
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = ProfileViewModel()
        super.init(nibName: nil, bundle: nil)
        layout()
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
    
    // MARK: Bind View Model
    override func bind() {
//        viewModel.output.posts
//            .drive(postCollectionView.rx.items(cellIdentifier: ReelsCollectionCell.defaultReuseIdentifier, cellType: ReelsCollectionCell.self)) { _, _, cell in
//                cell.layer.cornerRadius = 6
//            }
//            .disposed(by: disposeBag)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        Observable.just(mockSession)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    // MARK: - Layout
    override func layout() {
        
        attribute()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func attribute() {
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (UIScreen.main.bounds.width - 12 - 40) / 2.0
        let itemHeight = itemWidth * 1.65
        
        print("\n\n\n\n\n\n\n")
        print(itemWidth, itemHeight)
        print("\n\n\n\n\n\n\n")
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
    }
}
