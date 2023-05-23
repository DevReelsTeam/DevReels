//
//  PostDTO.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/17.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct ReelsResponseDTO: Codable {
    private let id: StringValue
    private let uid: StringValue
    private let videoURL: StringValue
    private let thumbnailURL: StringValue
    private let title: StringValue
    private let videoDescription: StringValue
    
    func toDomain() -> Reels {
        return Reels(
            id: id.value,
            uid: uid.value,
            videoURL: videoURL.value,
            thumbnailURL: thumbnailURL.value,
            title: title.value,
            videoDescription: videoDescription.value
        )
    }
}
