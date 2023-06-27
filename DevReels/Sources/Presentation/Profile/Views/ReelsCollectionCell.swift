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
    
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let likeCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.text = "123"
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        
        self.addSubview(likeImageView)
        
        
        self.addSubview(likeCount)
        likeCount.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.Like.topMargin)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(Metric.Like.bottomMargin)
        }
        
        self.addSubview(commentImageView)
        
        self.addSubview(commentCount)
        commentCount.snp.makeConstraints { make in
            make.centerY.equalTo(likeCount)
            make.left.equalTo(likeCount.snp.right).offset(Metric.Comment.leftMargin)
        }
    }
}
