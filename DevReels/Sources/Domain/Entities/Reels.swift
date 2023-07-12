//
//  Video.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct Reels: Codable {
    let id: String
    let uid: String?
    let videoURL: String?
    let thumbnailURL: String?
    let title: String
    let videoDescription: String
    
    init(id: String, uid: String?, videoURL: String?, thumbnailURL: String?, title: String, videoDescription: String) {
        self.id = id
        self.uid = uid
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.videoDescription = videoDescription
    }
        
    init(id: String, title: String, videoDescription: String) {
        self.id = id
        self.uid = nil
        self.videoURL = nil
        self.thumbnailURL = nil
        self.title = title
        self.videoDescription = videoDescription
    }
}
