//
//  CommentDataSource.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/29.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift
import Firebase

struct CommentDataSource: CommentDataSourceProtocol {
    
    let fireStore = Firestore.firestore().collection("reelsList")
    
    func upload(request: CommentRequestDTO) -> Observable<Void> {
        
        return Observable.create { emitter in
            fireStore.document(request.reelsID)
                .collection("comments")
                .document(request.commentID)
                .setData(request.toDictionary()) { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
    
    func read(reelsID: String) -> Observable<[CommentResponseDTO]> {
        return Observable.create { emitter in
            fireStore.document(reelsID)
                .collection("comments")
                .getDocuments(completion: { snapshot, _ in
                    
                    if let snapshot = snapshot?.documents {
                        let comments = snapshot
                            .map { $0.data() }
                            .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                            .compactMap { try? JSONDecoder().decode(Comment.self, from: $0) }
                            .map { CommentResponseDTO(comment: $0) }
                        
                        emitter.onNext(comments)
                    }
                })
            return Disposables.create()
        }
    }
    
    func delete(request: CommentRequestDTO) -> Observable<Void> {
        return Observable.create { emitter in
            fireStore.document(request.reelsID)
                .collection("comments")
                .document(request.commentID)
                .delete { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
}


// api로 진행하니 collection의 이름을 지정 못함 그래서 upload, fetch 하는 방법을 찾지 못함.. 모각코에서 컬렉션 이름을 지정하는 소스가 없고 여러 방법으로 시도해봤으나 해결하지 못함..
//struct CommentDataSource {
//
//    private let provider: Provider
//
//    init() {
//        self.provider = Provider.default
//    }
//
//    func list() -> Observable<Documents<[ReelsResponseDTO]>> {
//        return provider.request(ReelsTarget.list)
//    }
//
//    func upload(reqeust: CommentRequestDTO) -> Observable<Void> {
//        return provider.request(CommentTarget.upload(reqeust))
//    }
//}
//
//enum CommentTarget {
//    case commentList(String)
//    case upload(CommentRequestDTO)
//}
//
//extension CommentTarget: TargetType {
//    var baseURL: String {
//        return Network.baseURLString + "/documents/comments"
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        case .commentList:
//            return .get
//        case .upload:
//            return .post
//        }
//    }
//
//    var header: HTTPHeaders {
//        return [
//            "Content-Type": "application/json"
//        ]
//    }
//
//    var path: String {
//        switch self {
//        case .upload(let data):
////            return "/?documentId=\(data.reelsID.value)"
////            return "/\(data.reelsID.value)/\(data.commentID.value)/?collectionId=\(data.commentID.value)"
//
//
//        default:
//            return ""
//        }
//    }
//
//    var parameters: RequestParams? {
//        switch self {
//        case .upload(let data):
//            return .body(data)
//        case .commentList(let data):
//            return .body(data)
//        }
//    }
//
//    var encoding: ParameterEncoding {
//        return JSONEncoding.default
//    }
//}
