//
//  ReelsDataSource.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxDevReelsYa
import RxSwift

struct ReelsDataSource: ReelsDataSourceProtocol {
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func list() -> Observable<Documents<[ReelsResponseDTO]>> {
        print("DataSource의 함수가 불렸다.")
        return provider.request(ReelsTarget.list)
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
