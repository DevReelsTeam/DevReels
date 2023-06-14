//
//  UploadReelsUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/06/13.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UploadReelsUsecaseProtocol {
    func upload(title: String, description: String, videoData: Data) -> Observable<Void>
}
