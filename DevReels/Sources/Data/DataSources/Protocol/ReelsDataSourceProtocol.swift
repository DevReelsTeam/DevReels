//
//  ReelsDataSourceProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

protocol ReelsDataSourceProtocol {
    func list() -> Observable<Documents<[ReelsResponseDTO]>>
}
