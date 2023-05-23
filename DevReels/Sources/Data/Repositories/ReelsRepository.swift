//
//  ReelsRepository.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

struct ReelsRepository: ReelsRepositoryProtocol {
    
    var reelsDataSource: ReelsDataSourceProtocol?
    
    func list() -> Observable<[Reels]> {
        return .empty()
    }
}
