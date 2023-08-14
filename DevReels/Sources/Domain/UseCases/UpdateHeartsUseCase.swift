//
//  UpdateHeartsUseCase.swift
//  DevReels
//
//  Created by Jerry on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UpdateHeartsUseCase: UpdateHeartsUseCaseProtocol {
    var userRepository: UserRepositoryProtocol?
    var reelsRepository: ReelsRepositoryProtocol?
    
    private let disposeBag = DisposeBag()
    
    // TODO: - 업데이트해야하는 데이터 아직 안넣었음
    func updateUser(user: User, reels: Reels) {
        
    }
    
    func updateReels(hearts: Int, reels: Reels) {
        
    }
    
    func addHeart(uid: String, reels: Reels) {
        let reels = Reels(id: reels.id,
                          title: reels.title,
                          videoDescription: reels.videoDescription,
                          githubUrl: reels.githubUrl,
                          blogUrl: reels.blogUrl,
                          likedList: reels.likedList + [uid],
                          date: reels.date,
                          uid: reels.uid,
                          videoURL: reels.videoURL,
                          thumbnailURL: reels.thumbnailURL)
        
        reelsRepository?.update(reels: reels)
    }
    
    func removeHeart(uid: String, reels: Reels) {
        let reels = Reels(id: reels.id,
                          title: reels.title,
                          videoDescription: reels.videoDescription,
                          githubUrl: reels.githubUrl,
                          blogUrl: reels.blogUrl,
                          likedList: reels.likedList.filter { $0 != uid },
                          date: reels.date,
                          uid: reels.uid,
                          videoURL: reels.videoURL,
                          thumbnailURL: reels.thumbnailURL)
        
        reelsRepository?.update(reels: reels)
    }
}
