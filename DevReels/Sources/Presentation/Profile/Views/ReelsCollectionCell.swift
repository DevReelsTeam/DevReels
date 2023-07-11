//
//  ReelsCollectionCell.swift
//  DevReels
//
//  Created by 강현준 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ReelsCollectionCell: UICollectionViewCell, Identifiable {
    
    // MARK: - Constants
    private enum Metrics {
        enum ThumbnailImageView {
            static let height = 245
            static let cornerRadius: CGFloat = 8
        }
        
        enum Title {
            static let leadingMargin = 8
            static let bottomMargin = 11
        }
        
        enum Like {
            static let topMargin = 6
            static let imageViewLeadingMargin = 8
            static let countLabelLeadingMargin = 2
        }
        
        enum Comment {
            static let imageViewLeadingMargin = 8
            static let countLabelLeadingMargin = 2
        }
    }
    
    private let thumbnailImageView = UIImageView().then {
        $0.imageURL = "https://firebasestorage.googleapis.com/v0/b/devreels.appspot.com/o/tempUID%2Fimages%2FE6F9553F-19C2-4AB6-ADB2-137F0BB8344C1687708291.981889?alt=media&token=f28888cf-ef46-4591-866c-b2c73fb1ec08"
        
        $0.layer.cornerRadius = Metrics.ThumbnailImageView.cornerRadius
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .black
        $0.text = "UI 낙엽 애니메이션 구현하기"
    }
    
    private let likeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart")
        $0.tintColor = .devReelsColor.neutral60
    }
    
    private let likeCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.text = "123"
    }
    
    private let commentImageView = UIImageView().then {
        $0.image = UIImage(systemName: "bubble.right")
        $0.tintColor = .devReelsColor.neutral60
    }
    
    private let commentCountLabel = UILabel().then {
         $0.font = .systemFont(ofSize: 12)
         $0.textColor = .white
         $0.text = "123"
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func layout() {
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.lessThanOrEqualTo(Metrics.ThumbnailImageView.height)
        }
        
        thumbnailImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metrics.Title.leadingMargin)
            $0.bottom.equalToSuperview().inset(Metrics.Title.bottomMargin)
        }
        
        contentView.addSubview(likeImageView)
        
        likeImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(Metrics.Like.topMargin)
            $0.leading.equalToSuperview().offset(Metrics.Like.imageViewLeadingMargin)
        }
        
        contentView.addSubview(likeCountLabel)
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView)
            $0.leading.equalTo(likeImageView.snp.trailing).offset(Metrics.Like.countLabelLeadingMargin)
        }
        
        contentView.addSubview(commentImageView)
        
        commentImageView.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(Metrics.Comment.imageViewLeadingMargin)
        }
        
        contentView.addSubview(commentCountLabel)
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(Metrics.Comment.countLabelLeadingMargin)
        }
    }
}
