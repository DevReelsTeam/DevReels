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
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, uid, videoURL, thumbnailURL, title, videoDescription
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.uid = try fieldContainer.decode(StringValue.self, forKey: .uid)
        self.videoURL = try fieldContainer.decode(StringValue.self, forKey: .videoURL)
        self.thumbnailURL = try fieldContainer.decode(StringValue.self, forKey: .thumbnailURL)
        self.title = try fieldContainer.decode(StringValue.self, forKey: .title)
        self.videoDescription = try fieldContainer.decode(StringValue.self, forKey: .videoDescription)
    }
    
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
