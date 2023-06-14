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
        let reels = reelsDataSource?.list()
            .map { $0.documents.map { $0.toDomain() } }
        return reels ?? .empty()
    }
    
    func upload() -> Observable<Void> {
        return Observable.empty()
    }
    
//    func create(user: User, reels: Reels) -> Observable<Reels> {
//        
//    }
    
//    func create(user: User, reels: Reels) -> Observable<Reels> {
//        return Observable<Study>.create { emitter in
//
//            let createStudyRequest = StudyRequestDTO(study: Study(study: study, userIDs: [user.id]))
//            let createStudy = (studyDataSource?.create(study: createStudyRequest) ?? .empty())
//
//            let createChatRoomRequest = CreateChatRoomRequestDTO(id: study.id, studyID: study.id, userIDs: [user.id])
//            let createChatRoom = (chatRoomDataSource?.create(request: createChatRoomRequest) ?? .empty())
//                .flatMap {
//                    pushNotificationService?.subscribeTopic(topic: $0.toDomain().id) ?? .empty()
//                }
//
//            let updateUser = (remoteUserDataSource?.updateIDs(
//                id: user.id,
//                request: UpdateStudyIDsRequestDTO(
//                    chatRoomIDs: user.chatRoomIDs + [study.id],
//                    studyIDs: user.chatRoomIDs + [study.id]
//                )
//            ) ?? .empty())
//
//            Observable
//                .zip(createStudy, createChatRoom, updateUser)
//                .subscribe { data in emitter.onNext(data.0.toDomain()) }
//                .disposed(by: self.disposeBag)
//
//            return Disposables.create()
//        }
//    }
}
