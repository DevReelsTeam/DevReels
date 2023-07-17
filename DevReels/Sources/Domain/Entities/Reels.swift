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
    let title: String
    let videoDescription: String
    let githubUrl: String
    let blogUrl: String
    let hearts: Int
    let uid: String?
    let videoURL: String?
    let thumbnailURL: String?
    
    init(id: String, title: String,videoDescription: String, githubUrl: String, blogUrl: String, hearts: Int, uid: String?, videoURL: String?, thumbnailURL: String?) {
        self.id = id
        self.title = title
        self.videoDescription = videoDescription
        self.githubUrl = githubUrl
        self.blogUrl = blogUrl
        self.hearts = hearts
        self.uid = uid
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
    }
        
    init(id: String, title: String, videoDescription: String, githubUrl: String, blogUrl: String, hearts: Int) {
        self.id = id
        self.title = title
        self.videoDescription = videoDescription
        self.githubUrl = githubUrl
        self.blogUrl = blogUrl
        self.hearts = hearts
        self.uid = nil
        self.videoURL = nil
        self.thumbnailURL = nil
    }
    
    struct Constants {
        static let mockReels = Reels(id: "", title: "", videoDescription: "", githubUrl: "", blogUrl: "", hearts: 0)
    }
}
