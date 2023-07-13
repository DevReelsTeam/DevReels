//
//  ReelsRepository.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift
import Foundation

struct ReelsRepository: ReelsRepositoryProtocol {

    // keychainManager 추가
    var reelsDataSource: ReelsDataSourceProtocol?
    
    func list() -> Observable<[Reels]> {
        let reels = reelsDataSource?.list()
            .map { $0.documents.map { $0.toDomain() } }
        return reels ?? .empty()
    }
    
    func upload(reels: Reels, video: Data, thumbnailImage: Data) -> Observable<Void> {
        
        let uid = "tempUID"
        
        let videoURLObservable = reelsDataSource?.uploadFile(type: .video, uid: uid, file: video) ?? .empty()
        let thumbnailURLObservable = reelsDataSource?.uploadFile(type: .image, uid: uid, file: thumbnailImage) ?? .empty()
        
        let reelsRequest = Observable.zip(videoURLObservable, thumbnailURLObservable)
            .map { return ($0.0.absoluteString, $0.1.absoluteString) }
            .map {
                
                let reels = Reels(id: reels.id,
                                  title: reels.title,
                                  videoDescription: reels.videoDescription,
                                  githubUrlString: reels.githubUrlString,
                                  blogUrlString: reels.blogUrlString,
                                  uid: uid,
                                  videoURL: $0.0,
                                  thumbnailURL: $0.1)

                return ReelsRequestDTO(reels: reels)
            }
        
        return reelsRequest
            .flatMap { reelsDataSource?.upload(request: $0) ?? .empty() }
    }
}
