//
//  UploadReelsUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/06/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

<<<<<<< HEAD
struct UploadReelsUseCase {
        
    var reelsRepository: ReelsRepositoryProtocol?

    func upload(title: String, description: String, videoData: Data) -> Observable<Void> {
        print("업로드")
        return Observable.empty()
=======
struct UploadReelsUseCase: UploadReelsUsecaseProtocol {
    
    var reelsRepository: ReelsRepositoryProtocol?
    
    func upload(reels: Reels, video: Data, thumbnailImage: Data) -> Observable<Void> {
//        return (userRepository?.load() ?? .empty())
//            .flatMap { studyRepository?.create(user: $0, study: study) ?? .empty() }
        
        return reelsRepository?.upload(reels: reels, video: video, thumbnailImage: thumbnailImage) ?? .empty()
>>>>>>> 08e5781 (feat: UploadReels - Domain, Repository 추가.)
    }
}
