//
//  ReelsDataSource.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxDevReelsYa
import RxSwift
import Firebase

struct ReelsDataSource: ReelsDataSourceProtocol {
    
    enum FileType: String {
        case video = "videos"
        case image = "images"
        
        var contentTypeString: String {
            switch self {
            case .video:
                return "video/mp4"
            case .image:
                return "image/jpeg"
            }
        }
    }
    
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func list() -> Observable<Documents<[ReelsResponseDTO]>> {
        return provider.request(ReelsTarget.list)
    }
    
    func upload(request: ReelsRequestDTO) -> Observable<Void> {
        return provider.request(ReelsTarget.upload(request))
    }
        
    func uploadFile(type: FileType, uid: String, file: Data) -> Observable<URL> {
        return Observable.create { emitter in
            
            let fileName = UUID().uuidString + String(Date().timeIntervalSince1970)
            let metaData = StorageMetadata()
            metaData.contentType = type.contentTypeString
            
            let ref = Storage.storage().reference().child(uid).child(type.rawValue).child(fileName)
            ref.putData(file, metadata: metaData) { _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                ref.downloadURL { url, error in
                    guard let url else {
                        if let error = error {
                            emitter.onError(error)
                        }
                        return
                    }
                    emitter.onNext(url)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}

enum ReelsTarget {
    case list
    case upload(ReelsRequestDTO)
}

extension ReelsTarget: TargetType {
    var baseURL: String {
        return Network.baseURLString + "/documents/reels"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .upload:
            return .post
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .upload(let reels):
            return "/?documentId=\(reels.id.value)"
        default:
            return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list:
            return nil
        case .upload(let reels):
            return .body(reels)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
