//
//  UserDataSource.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Firebase
import FirebaseFirestore
import RxSwift

struct UserDataSource: UserDataSourceProtocol {
    
    let fireStore = Firestore.firestore().collection("users")
    
    // 유저 생성
    func create(request: UserRequestDTO) -> Observable<Void> {
        return Observable.create { emitter in
            fireStore.document(request.uid).getDocument { snapshot, _ in
                if snapshot?.data() == nil {
                    self.fireStore.document(request.uid)
                        .setData(request.toDictionary()) { _ in
                            emitter.onNext(())
                        }
                } else {
                    emitter.onNext(())
                }
            }
            return Disposables.create()
        }
    }
    
    // 유저 읽어오기 - 작동 확인
    func read(uid: String) -> Observable<UserResponseDTO> {
        return Observable.create { emitter in
            fireStore.document(uid).getDocument { snapshot, _ in
                if let data = snapshot?.data(),
                   let response = try? JSONSerialization.data(withJSONObject: data),
                   let decoded = try? JSONDecoder().decode(User.self, from: response) {
                    
                    emitter.onNext(UserResponseDTO(user: decoded))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func fetchFollower(uid: String) -> Observable<[UserResponseDTO]> {
        return Observable.create { emitter in
            fireStore.document(uid)
                .collection("follower")
                .getDocuments { snapshot, _ in
                if let documents = snapshot?.documents {
                    let followers = documents
                        .map { $0.data() }
                        .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                        .compactMap { try? JSONDecoder().decode(User.self, from: $0) }
                        .map { UserResponseDTO(user: $0) }
                    
                    emitter.onNext(followers)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchFollowing(uid: String) -> Observable<[UserResponseDTO]> {
        return Observable.create { emitter in
            fireStore.document(uid)
                .collection("following")
                .getDocuments { snapshot, _ in
                    if let documents = snapshot?.documents {
                        let following = documents
                            .map { $0.data() }
                            .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                            .compactMap { try? JSONDecoder().decode(User.self, from: $0) }
                            .map { UserResponseDTO(user: $0) }
                        
                        emitter.onNext(following)
                    }
                }
            return Disposables.create()
        }
    }
    
    func follow(targetUserData: User, myUserData: User) -> Observable<Void> {
        return Observable.create { emitter in
            
            fireStore.document(targetUserData.uid)
                .collection("follower")
                .document(myUserData.uid)
                .setData(myUserData.toDictionary()) { _ in
                    fireStore.document(myUserData.uid)
                        .collection("following")
                        .document(targetUserData.uid)
                        .setData(targetUserData.toDictionary()) { _ in
                            emitter.onNext(())
                            emitter.onCompleted()
                        }
                }
            
            return Disposables.create()
        }
    }
    
    func unfollow(targetUserData: User, myUserData: User) -> Observable<Void> {
        return Observable.create { emitter in
            fireStore.document(targetUserData.uid)
                .collection("follower")
                .document(myUserData.uid)
                .delete(completion: { _ in
                    fireStore.document(myUserData.uid)
                        .collection("following")
                        .document(targetUserData.uid)
                        .delete(completion: { _ in
                            emitter.onNext(())
                            emitter.onCompleted()
                        })
                })
            
            return Disposables.create()
        }
    }
    
    func update(user: User) {
        fireStore.document(user.uid)
            .updateData(user.toDictionary())
    }
}
