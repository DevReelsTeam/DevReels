//
//  ReelsRequestDTO.swift
//  DevReels
//
//  Created by HoJun on 2023/06/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct ReelsRequestDTO: Codable {
    let id: StringValue
    let uid: StringValue
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.id, forKey: .id)
        try fieldContainer.encode(self.uid, forKey: .uid)
        try fieldContainer.encode(self.videoURL, forKey: .videoURL)
        try fieldContainer.encode(self.thumbnailURL, forKey: .thumbnailURL)
        try fieldContainer.encode(self.title, forKey: .title)
        try fieldContainer.encode(self.videoDescription, forKey: .videoDescription)
    }
    
    init(reels: Reels) {
        self.id = StringValue(value: reels.id)
        self.uid = StringValue(value: reels.uid ?? "")
        self.videoURL = StringValue(value: reels.videoURL ?? "")
        self.thumbnailURL = StringValue(value: reels.thumbnailURL ?? "")
        self.title = StringValue(value: reels.title)
        self.videoDescription = StringValue(value: reels.videoDescription)
    }
}
