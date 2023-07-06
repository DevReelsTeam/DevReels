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
    let writerProfileImageURL: String
    let content: String
    let date: Int
    let likes: Int

    init(comment: Comment) {
        self.commentID = UUID().uuidString
        self.reelsID = comment.reelsID
        self.writerID = comment.writerID
        self.writerProfileImageURL = comment.writerProfileImageURL
        self.content = comment.content
        self.date = comment.date
        self.likes = comment.likes
    }
    
    init(deleteComment: Comment) {
        self.commentID = deleteComment.commentID
        self.reelsID = deleteComment.reelsID
        self.writerID = deleteComment.writerID
        self.writerProfileImageURL = deleteComment.writerProfileImageURL
        self.content = deleteComment.content
        self.date = deleteComment.date
        self.likes = deleteComment.likes
    }
}
