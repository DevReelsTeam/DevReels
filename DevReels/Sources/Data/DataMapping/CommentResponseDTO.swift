//
//  CommentResponseDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct CommentResponseDTO: Encodable {
    let commentID: StringValue
    let reelsID: StringValue
    let writerID: StringValue
    let content: StringValue
    let date: IntegerValue
    let likes: IntegerValue
    
    init(comment: Comment) {
        self.commentID = StringValue(value: comment.commentID)
        self.reelsID = StringValue(value: comment.reelsID)
        self.writerID = StringValue(value: comment.writerID)
        self.content = StringValue(value: comment.content)
        self.date = IntegerValue(value: "\(comment.date)")
        self.likes = IntegerValue(value: "\(comment.likes)")
    }
}
