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
import DRVideoController
import RxSwift
import RxCocoa

final class ReelsCell: UITableViewCell, Identifiable {
    // MARK: - Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "릴스 제목"
        $0.textColor = .white
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "설명"
        $0.textColor = .white
    }
    
    private lazy var heartImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart")
        $0.tintColor = .white
    }
    
    private lazy var heartNumberLabel = UILabel().then {
        $0.text = "5.0k"
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private lazy var commentImageView = RxUIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "bubble.left")
        $0.tintColor = .white
    }
    
    private lazy var commentNumberLabel = UILabel().then {
        $0.text = "25"
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private lazy var shareImageView = UIImageView().then {
        $0.image = UIImage(systemName: "arrow.turn.up.right")
        $0.tintColor = .white
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .black
    }
    
    private lazy var bottomGradientImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    lazy var videoLayer = AVPlayerLayer().then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        $0.backgroundColor = UIColor.clear.cgColor
        $0.videoGravity = AVLayerVideoGravity.resize
    }
    
    private let videoController = VideoPlayerController.sharedVideoPlayer
    
    var reels: Reels?
    var commentButtonTap = PublishSubject<Reels>()
    var disposeBag = DisposeBag()
    
    private var videoURL: String? {
        didSet {
            if let videoURL = videoURL {
                videoController.setupVideoFor(url: videoURL)
            }
            videoLayer.isHidden = videoURL == nil
        }
    }
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        commentImageView.tapEvent
            .subscribe(onNext: { [weak self] in
                self?.commentButtonTap
                    .onNext(self?.reels ?? Reels(id: "", uid: "", videoURL: "", thumbnailURL: "", title: "", videoDescription: ""))
            })
            .disposed(by: disposeBag)
        
        layout()
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        thumbnailImageView.imageURL = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradient()
        videoController.playVideo(withLayer: videoLayer, url: videoURL ?? "")
        print("\(self.reels?.id)")
    }
    
    func configureGradient() {
        let color1 = UIColor.black.withAlphaComponent(0.0)
        let color2 = UIColor.black.withAlphaComponent(0.7)
        let gradient = UIImage.createGradient(color1: color1, color2: color2, frame: bottomGradientImageView.bounds)
        bottomGradientImageView.image = gradient
    }
    
    func configureCell(data: Reels) {
        self.thumbnailImageView.imageURL = data.thumbnailURL
        self.videoURL = data.videoURL
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.videoDescription
        self.reels = data
    }
    
    // MARK: - Layout
    private func layout() {
        contentView.addSubViews([thumbnailImageView, bottomGradientImageView, titleLabel, descriptionLabel, heartImageView, heartNumberLabel, commentImageView, commentNumberLabel, shareImageView])

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(-150)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-120)
            $0.leading.equalTo(thumbnailImageView.snp.leading).offset(20)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-20)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        thumbnailImageView.layer.addSublayer(videoLayer)

        bottomGradientImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-120)
            $0.leading.equalTo(thumbnailImageView.snp.leading)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom)
        }
                
        heartImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-400)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(-60)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-20)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-360)
        }
        
        heartNumberLabel.snp.makeConstraints {
            $0.top.equalTo(heartImageView.snp.bottom).offset(0)
            $0.leading.equalTo(heartImageView.snp.leading)
            $0.trailing.equalTo(heartImageView.snp.trailing)
            $0.bottom.equalTo(heartImageView.snp.bottom).offset(40)
        }
        
        commentImageView.snp.makeConstraints {
            $0.top.equalTo(heartNumberLabel.snp.bottom).offset(40)
            $0.leading.equalTo(heartImageView.snp.leading)
            $0.trailing.equalTo(heartImageView.snp.trailing)
            $0.bottom.equalTo(heartNumberLabel.snp.bottom).offset(80)
        }
        
        commentNumberLabel.snp.makeConstraints {
            $0.top.equalTo(commentImageView.snp.bottom).offset(0)
            $0.leading.equalTo(heartImageView.snp.leading)
            $0.trailing.equalTo(heartImageView.snp.trailing)
            $0.bottom.equalTo(commentImageView.snp.bottom).offset(40)
        }
    }
}
