//
//  VideoPlayerController.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayVideoLayerContainer {
    var videoURL: String? { get set }
    var videoLayer: AVPlayerLayer { get set }
    func visibleVideoHeight() -> CGFloat
}

final class VideoPlayerController: NSObject, NSCacheDelegate {
    var shouldPlay = true {
        didSet {
            self.currentVideoContainer()?.shouldPlay = shouldPlay
        }
    }
    var minimumLayerHeightToPlay: CGFloat = 60
    var mute = false
    var preferredPeakBitRate: Double = 1000000
    static private var playerViewControllerKVOContext = 0
    static let sharedVideoPlayer = VideoPlayerController()

    private var videoURL: String?
    
    /// 동영상 URL을 키로 저장하고 플레이어 항목이 URL에 연결될 때 True로 저장합니다
    /// 상태 변경에 대해 관찰 중입니다.
    /// 재생되지 않는 플레이어 항목에 대한 관찰자를 제거하는 데 도움이 됩니다.
    private var observingURLs: [String: Bool] = [:]

    private var videoCache = NSCache<NSString, VideoContainer>()
    private var videoLayers = VideoLayers()

    private var currentLayer: AVPlayerLayer?
    override init() {
        super.init()
        videoCache.delegate = self
    }
    /// URL에 해당하는 Video Container가 없을 경우 asset을 다운로드합니다.
    /// asset을 이용하여 새로운 플레이어 목록을 만듭니다.
    func setupVideoFor(url: String) {
        if self.videoCache.object(forKey: url as NSString) != nil {
            return
        }
        guard let URL = URL(string: url) else {
            return
        }
        let asset = AVURLAsset(url: URL)
        let requestedKeys = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKeys) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            /*
             자산이 성공적으로 로드되었는지 확인한 후,
             실패할 경우 AVPlayer 및 AVPlayerItem을 생성하지 않고 비디오 컨테이너를
             캐시하지 않은 채로 반환하여 필요할때 다시 다운로드 할 수 있도록합니다.
             */
            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                break
            case .failed, .cancelled:
                print("DEBUG:: asset을 성공적으로 불러오지 못했습니다.")
                return
            default:
                print("DEBUG:: asset의 상태를 알 수 없습니다.")
                return
            }
            let player = AVPlayer()
            let item = AVPlayerItem(asset: asset)
            DispatchQueue.main.async {
                let videoContainer = VideoContainer(player: player, item: item, url: url)
                strongSelf.videoCache.setObject(videoContainer, forKey: url as NSString)
                videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
                /*
                 playVideo메서드가 호출되고 asset을 얻지 못한 경우,
                 이전 비디오가 실행되지 않았으므로 비디오를 다시 재생합니다.
                 */
                if strongSelf.videoURL == url, let layer = strongSelf.currentLayer {
                    strongSelf.playVideo(withLayer: layer, url: url)
                }
            }
        }
    }
    
    func playVideo(withLayer layer: AVPlayerLayer, url: String) {
        videoURL = url
        currentLayer = layer
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            layer.player = videoContainer.player
            videoContainer.playOn = true
            addObservers(url: url, videoContainer: videoContainer)
        }
        DispatchQueue.main.async {
            if let videoContainer = self.videoCache.object(forKey: url as NSString),
               videoContainer.player.currentItem?.status == .readyToPlay {
                videoContainer.playOn = true
            }
        }
        NotificationCenter.default.post(name: Notification.Name("STARTED_PLAYING"), object: nil, userInfo: nil)
    }
    private func pauseVideo(forLayer layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
    }
    func removeLayerFor(cell: PlayVideoLayerContainer) {
        if let url = cell.videoURL {
            removeFromSuperLayer(layer: cell.videoLayer, url: url)
        }
    }
    private func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
        layer.player = nil
    }
    private func pauseRemoveLayer(layer: AVPlayerLayer, url: String, layerHeight: CGFloat) {
        pauseVideo(forLayer: layer, url: url)
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
              let currentPlayer = currentVideoContainer()?.player else {
            return
        }
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
            currentPlayer.seek(to: CMTime.zero)
            currentPlayer.play()
        }
    }
    private func currentVideoContainer() -> VideoContainer? {
        if let currentVideoUrl = videoURL {
            if let videoContainer = videoCache.object(forKey: currentVideoUrl as NSString) {
                return videoContainer
            }
        }
        return nil
    }
    private func addObservers(url: String, videoContainer: VideoContainer) {
        if self.observingURLs[url] == false || self.observingURLs[url] == nil {
            videoContainer.player.currentItem?.addObserver(
                self,
                forKeyPath: "status",
                options: [.new, .initial],
                context: &VideoPlayerController.playerViewControllerKVOContext)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: videoContainer.player.currentItem)
            self.observingURLs[url] = true
        }
    }
    private func removeObserverFor(url: String) {
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            if let currentItem = videoContainer.player.currentItem, observingURLs[url] == true {
                currentItem.removeObserver(self,
                                           forKeyPath: "status",
                                           context: &VideoPlayerController.playerViewControllerKVOContext)
                NotificationCenter.default.removeObserver(self,
                                                          name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                          object: currentItem)
                observingURLs[url] = false
            }
        }
    }
    /// 스크롤이 멈출 때 최대로 보이는 비디오 레이어 높이를 가진 UITableViewCell의 비디오 플레이어를 재생합니다.
    func pausePlayeVideosFor(tableView: UITableView, appEnteredFromBackground: Bool = false) {
        let visisbleCells = tableView.visibleCells
        var videoCellContainer: PlayVideoLayerContainer?
        var maxHeight: CGFloat = 0.0
        for cellView in visisbleCells {
            guard let containerCell = cellView as? PlayVideoLayerContainer,
                  let videoCellURL = containerCell.videoURL else {
                continue
            }
            let height = containerCell.visibleVideoHeight()
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = containerCell
            }
            pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
        }
        guard let videoCell = videoCellContainer,
              let videoCellURL = videoCell.videoURL else {
            return
        }
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5
        /*
         비디오 재생을 위해, 비디오 레이어의 높이는 최소 높이와 셀의 비디오 레이어 높이의 50% 중 더 큰 값보다 크거나 같아야 합니다.
         */
        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        }
    }
    /// 캐시에서 객체가 제거될 때, 관찰 대상 URL을 false로 설정합니다.
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? VideoContainer {
            observingURLs[videoObject.url] = false
        }
    }
    // 현재 비디오 URL의 플레이어가 재생 준비가 되었을 때에만 비디오를 재생합니다.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &VideoPlayerController.playerViewControllerKVOContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        if keyPath == "status" {
            let newStatus: AVPlayerItem.Status
            if let newStatusAsNumber = change?[NSKeyValueChangeKey.newKey] as? NSNumber {
                newStatus = AVPlayerItem.Status(rawValue: newStatusAsNumber.intValue) ?? .failed
                if newStatus == .readyToPlay {
                    guard let item = object as? AVPlayerItem,
                          let currentItem = currentVideoContainer()?.player.currentItem else {
                        return
                    }
                    if item == currentItem && currentVideoContainer()?.playOn == true {
                        currentVideoContainer()?.playOn = true
                    }
                }
            } else {
                newStatus = .unknown
            }
        }
    }
    deinit {
        print("DEBUG:: 비디오레이어 해제 - 리테인 사이클, 메모리 누수 없음")
    }
}
