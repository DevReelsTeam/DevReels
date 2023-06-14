//
//  UploadReelsUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/06/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UploadReelsUseCase {
        
    var reelsRepository: ReelsRepositoryProtocol?

    func upload(title: String, description: String, videoData: Data) -> Observable<Void> {
        print("업로드")
        return Observable.empty()
    }
}
