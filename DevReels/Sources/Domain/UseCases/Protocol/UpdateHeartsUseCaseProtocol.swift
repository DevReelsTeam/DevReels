//
//  UpdateHeartsUseCaseProtocol.swift
//  DevReels
//
//  Created by Jerry on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UpdateHeartsUseCaseProtocol {
    func addHeart(uid: String, reels: Reels)
    func removeHeart(uid: String, reels: Reels)
}
