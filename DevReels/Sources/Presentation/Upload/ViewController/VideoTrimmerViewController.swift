//
//  TrimVideoViewController.swift
//  DevReels
//
//  Created by HoJun on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import PryntTrimmerView
import SnapKit
import Then
import PhotosUI

final class VideoTrimmerViewController: ViewController {

    private lazy var playButton = UIButton().then {
        $0.backgroundColor = .blue
        $0.setTitle("플레이", for: .normal)
        $0.addTarget(self, action: #selector(play), for: .touchUpInside)
    }
    
    private lazy var selectAssetButton = UIButton().then {
        $0.backgroundColor = .red
        $0.setImage(UIImage(systemName: "square.stack"), for: .normal)
        $0.addTarget(self, action: #selector(selectAsset), for: .touchUpInside)
    }
    
    private lazy var hStack = UIStackView(arrangedSubviews: [playButton, selectAssetButton]).then {
        $0.distribution = .fillEqually
        $0.spacing = 30
        $0.axis = .horizontal
    }
    
    private let playerView = UIView()
    private let trimmerView = TrimmerView()
    
    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?
    
    private var videoPicker: PHPickerViewController?
    private var videoURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trimmerView.handleColor = UIColor.white
        trimmerView.mainColor = UIColor.darkGray
        trimmerView.minDuration = 10
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configurePicker()
    }

    @objc func selectAsset(_ sender: Any) {
        presentPicker()
    }

    @objc func play(_ sender: Any) {

        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }
    
    func loadAsset(_ asset: AVAsset) {
        trimmerView.asset = asset
        trimmerView.delegate = self
        addVideoPlayer(with: asset, playerView: playerView)
    }

    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(VideoTrimmerViewController.itemDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: playerItem)

        let layer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        playerView.layer.addSublayer(layer)
    }

    @objc func itemDidFinishPlaying(_ notification: Notification) {
        if let startTime = trimmerView.startTime {
            guard let player else { return }
            player.seek(to: startTime)
            if !player.isPlaying {
                player.play()
            }
        }
    }

    func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                        target: self,
                                                        selector: #selector(onPlaybackTimeChecker),
                                                        userInfo: nil,
                                                        repeats: true)
    }

    func stopPlaybackTimeChecker() {

        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {

        guard let startTime = trimmerView.startTime, let endTime = trimmerView.endTime, let player = player else {
            return
        }

        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
        }
    }
    
    override func layout() {
        view.backgroundColor = .white
        
        playerView.backgroundColor = .gray
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalToSuperview().multipliedBy(0.65)
        }
        
        view.addSubview(trimmerView)
        trimmerView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(30)
            make.width.equalTo(playerView)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        hStack.backgroundColor = .gray
        view.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.equalToSuperview().offset(0.7)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: Tirmmer Delegate

extension VideoTrimmerViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        if let start = trimmerView.startTime,
           let end = trimmerView.endTime {
            let duration = (end - start).seconds
            print(duration)
        }
    }
}


// MARK: Picker

extension VideoTrimmerViewController {
    private func configurePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 1
        videoPicker = PHPickerViewController(configuration: configuration)
        videoPicker?.delegate = self
    }
    
    private func presentPicker() {
        guard let videoPicker else { return }
        present(videoPicker, animated: true)
    }
}

// MARK: Picker Delegate

extension VideoTrimmerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: [:]) { [weak self] videoURL, _ in
                DispatchQueue.main.async {
                    if let url = videoURL as? URL {
                        let asset = AVAsset(url: url)
                        self?.loadAsset(asset)
                    }
                }
            }
        }
    }
}
