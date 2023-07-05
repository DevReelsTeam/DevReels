//
//  UserDataSourceProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDataSourceProtocol {
    func create(request: UserRequestDTO) -> Observable<Void>
    func read(uid: String) -> Observable<UserResponseDTO>
}
