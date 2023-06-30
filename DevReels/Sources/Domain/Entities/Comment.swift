//
//  Comment.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/29.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let commentID: String
    let reelsID: String
    let writerID: String
    let content: String
    let date: Int
    let likes: Int
}
