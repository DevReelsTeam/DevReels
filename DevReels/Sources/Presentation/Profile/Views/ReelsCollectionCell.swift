//
//  ReelsCollectionCell.swift
//  DevReels
//
//  Created by Sh Hong on 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit

class ReelsCollectionCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Metric {
        enum ThumbnailImageView {
            static let height = 245
        }
        
        enum Title {
            static let topMargin = 9
            static let leftMargin = 14
        }
        
        enum Like {
            static let topMargin = 11
            static let bottomMargin = 14
        }
        
        enum Comment {
            static let leftMargin = 10
        }
    }
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "UI 낙엽 애니메이션 구현하기"
        return label
    }()
    
    private let likeCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.text = "123"
        return label
    }()
    
    private let commentCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.text = "123"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .init(red: 29, green: 31, blue: 49, alpha: 1)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func layout() {

        self.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(Metric.ThumbnailImageView.height)
        }

        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(Metric.Title.topMargin)
            make.left.equalToSuperview().inset(Metric.Title.leftMargin)
        }

        self.addSubview(likeCount)
        likeCount.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.Like.topMargin)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(Metric.Like.bottomMargin)
        }

        self.addSubview(commentCount)
        commentCount.snp.makeConstraints { make in
            make.centerY.equalTo(likeCount)
            make.left.equalTo(likeCount.snp.right).offset(Metric.Comment.leftMargin)
        }
    }
}

public protocol ReusableView: AnyObject {
    /// Get identifier from class
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        // Set the Identifier from class name
        return NSStringFromClass(self)
    }
}

extension UITableViewCell: ReusableView {
    
}

extension UITableView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}

extension UICollectionViewCell: ReusableView {
    
}

extension UICollectionView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
