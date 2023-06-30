//
//  CommentRequestDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/29.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct CommentRequestDTO: Encodable {
    let commentID: String
    let reelsID: String
    let writerID: String
    let content: String
    let date: Int
    let likes: Int

    init(reelsID: String, writerID: String, content: String, date: Int, likes: Int) {
        self.commentID = UUID().uuidString
        self.reelsID = reelsID
        self.writerID = writerID
        self.content = content
        self.date = date
        self.likes = likes
    }
}
