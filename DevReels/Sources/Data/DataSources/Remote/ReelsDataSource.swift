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
    
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func list() -> Observable<Documents<[ReelsResponseDTO]>> {
        return provider.request(ReelsTarget.list)
    }
    
    func uploadVideo(uid: String, videoData: Data) -> Observable<URL> {
        return Observable.create { emitter in
            let ref = Storage.storage().reference().child("Videos").child(uid)
            if let uploadData = videoData as Data? {
                ref.putData(videoData, metadata: nil) { _, error in
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
                    }
                }
            }
            return Disposables.create()
        }
    }
}

enum ReelsTarget {
    case list
}

extension ReelsTarget: TargetType {
    var baseURL: String {
        return Network.baseURLString + "/documents/reels"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    var path: String {
        switch self {
        default:
            return ""
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
