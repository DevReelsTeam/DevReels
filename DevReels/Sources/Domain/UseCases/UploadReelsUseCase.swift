//
//  UploadReelsUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/06/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UploadReelsUseCase: UploadReelsUsecaseProtocol {
    
    var reelsRepository: ReelsRepositoryProtocol?
    
    func upload(reels: Reels, video: Data, thumbnailImage: Data) -> Observable<Void> {
        return reelsRepository?.upload(reels: reels, video: video, thumbnailImage: thumbnailImage) ?? .empty()
    }
}
