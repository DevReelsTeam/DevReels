//
//  VideoLayers.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import AVFoundation

final class VideoLayerObject: NSObject {
    var layer = AVPlayerLayer()
    var used = false
    override init() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.videoGravity = AVLayerVideoGravity.resize
    }
}

struct VideoLayers {
    var layers = [VideoLayerObject]()
    init() {
        for _ in 0..<1 {
            layers.append(VideoLayerObject())
        }
    }
    func getLayerForParentLayer(parentLayer: CALayer) -> AVPlayerLayer {
        for videoObject in layers where videoObject.layer.superlayer == parentLayer {
            return videoObject.layer
        }
        return getFreeVideoLayer()
    }
    func getFreeVideoLayer() -> AVPlayerLayer {
        for videoObject in layers where videoObject.used == false {
            videoObject.used = true
            return videoObject.layer
        }
        return layers[0].layer
    }
    func freeLayer(layerToFree: AVPlayerLayer) {
        for videoObject in layers where videoObject.layer == layerToFree {
            videoObject.used = false
            videoObject.layer.player = nil
            if videoObject.layer.superlayer != nil {
                videoObject.layer.removeFromSuperlayer()
            }
            break
        }
    }
}

