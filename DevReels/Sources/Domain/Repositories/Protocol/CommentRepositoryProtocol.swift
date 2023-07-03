//
//  CommentRepositoryProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentRepositoryProtocol {
    func upload(reelsID: String, comment: Comment) -> Observable<Void>
    func fetch(reelsID: String) -> Observable<[Comment]>
}
