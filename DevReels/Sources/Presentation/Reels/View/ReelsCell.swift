//
//  ReelsCell.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class ReelsCell: UITableViewCell, Identifiable {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "릴스제목"
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "설명"
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private lazy var bottomGradientImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    var playerController: VideoPlayerController?
    var videoLayer = AVPlayerLayer()
    var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                VideoPlayerController.sharedVideoPlayer.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        let bottomGradient = Utilities.shared.createGradient(color1: UIColor.black.withAlphaComponent(0.0),
                                            color2: UIColor.black.withAlphaComponent(0.7),
                                            frame: bottomGradientImageView.bounds)
        bottomGradientImageView.contentMode = .scaleAspectFill
        bottomGradientImageView.image = bottomGradient
        self.contentView.backgroundColor = .random
        videoLayer.backgroundColor = UIColor.clear.cgColor
        videoLayer.videoGravity = AVLayerVideoGravity.resize
        thumbnailImageView.layer.addSublayer(videoLayer)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        thumbnailImageView.imageURL = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    private func layout() {
        contentView.addSubview(bottomGradientImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(thumbnailImageView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(-8)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-20)
            $0.leading.equalTo(thumbnailImageView.snp.leading).offset(20)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-20)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bottomGradientImageView.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }

    
    func configureCell(data: VideoObject) {
        self.thumbnailImageView.imageURL = data.thumbnailURL
        self.videoURL = data.videoURL
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.videoDescription
    }
}

extension ReelsCell: PlayVideoLayerContainer {
    
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(
            thumbnailImageView.frame,
            from: thumbnailImageView)
        guard let videoFrame = videoFrameInParentSuperView,
              let superViewFrame = superview?.frame else {
                  return 0
              }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}
