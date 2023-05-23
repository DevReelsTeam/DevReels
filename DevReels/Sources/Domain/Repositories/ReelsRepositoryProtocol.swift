//
//  ReelsRepositoryProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

protocol ReelsRepositoryProtocol {
    func list() -> Observable<[Reels]>
}
