//
//  Video.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct Reels {
    let id: String
    let title: String
    let videoDescription: String
    let githubUrlString: String
    let blogUrlString: String
    let uid: String?
    let videoURL: String?
    let thumbnailURL: String?
    
    init(id: String, title: String,videoDescription: String, githubUrlString: String, blogUrlString: String, uid: String?, videoURL: String?, thumbnailURL: String?) {
        self.id = id
        self.title = title
        self.videoDescription = videoDescription
        self.githubUrlString = githubUrlString
        self.blogUrlString = blogUrlString
        self.uid = uid
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
    }
        
    init(id: String, title: String, videoDescription: String, githubUrlString: String, blogUrlString: String) {
        self.id = id
        self.title = title
        self.videoDescription = videoDescription
        self.githubUrlString = githubUrlString
        self.blogUrlString = blogUrlString
        self.uid = nil
        self.videoURL = nil
        self.thumbnailURL = nil
    }
}
