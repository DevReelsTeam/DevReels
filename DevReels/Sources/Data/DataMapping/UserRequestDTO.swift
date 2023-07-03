//
//  UserRequestDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct UserRequestDTO: Encodable {
    let identifire: String
    let profileImageURLString: String
    let nickName: String
    let introduce: String
    let uid: String
    
    init(user: User) {
        self.identifire = user.identifire
        self.profileImageURLString = user.profileImageURLString
        self.nickName = user.nickName
        self.introduce = user.introduce
        self.uid = user.uid
    }
    
    init(uid: String, email: String) {
        self.identifire = email
        self.profileImageURLString = ""
        self.nickName = ""
        self.introduce = ""
        self.uid = uid
    }

}
