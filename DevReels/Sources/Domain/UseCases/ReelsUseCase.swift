//
//  ReelsUseCase.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct ReelsUseCase: ReelsUseCaseProtocol {
    
    var reelsRepository: ReelsRepositoryProtocol?
    
    func list() -> Observable<[Reels]> {
        return reelsRepository?.list() ?? .empty()
    }
}
