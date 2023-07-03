//
//  User.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct User: Codable {
    let identifire: String
    let profileImageURLString: String
    let nickName: String
    let introduce: String
    let uid: String
}

extension User {
    init(uid: String, identifire: String) {
        self.uid = uid
        self.identifire = identifire
        self.profileImageURLString = ""
        self.nickName = ""
        self.introduce = ""
    }
}
