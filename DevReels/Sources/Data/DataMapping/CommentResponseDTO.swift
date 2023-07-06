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
    let writerProfileImageURL: StringValue
    let content: StringValue
    let date: IntegerValue
    let likes: IntegerValue
    
    init(comment: Comment) {
        self.commentID = StringValue(value: comment.commentID)
        self.reelsID = StringValue(value: comment.reelsID)
        self.writerID = StringValue(value: comment.writerID)
        self.writerProfileImageURL = StringValue(value: comment.writerProfileImageURL)
        self.content = StringValue(value: comment.content)
        self.date = IntegerValue(value: "\(comment.date)")
        self.likes = IntegerValue(value: "\(comment.likes)")
    }
    
    func toDomain() -> Comment {
        return Comment(
            commentID: commentID.value,
            reelsID: reelsID.value,
            writerID: writerID.value,
            writerProfileImageURL: writerProfileImageURL.value,
            content: content.value,
            date: Int(date.value) ?? 0,
            likes: Int(likes.value) ?? 0
        )
    }
}
