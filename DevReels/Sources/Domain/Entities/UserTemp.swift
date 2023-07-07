//
//  UserTemp.swift
//  DevReels
//
//  Created by HoJun on 2023/07/07.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct UserTemp {
    let uid: String
    let identifier: String
    let fcmToken: String
    let profileImageURLString: String?
    let nickName: String?
    let githubURLString: String?
    let blogURLString: String?
    let introduce: String?
    
    init(uid: String, identifier: String, fcmToken: String) {
        self.uid = uid
        self.identifier = identifier
        self.fcmToken = fcmToken
        profileImageURLString = nil
        nickName = nil
        githubURLString = nil
        blogURLString = nil
        introduce = nil
    }
}
