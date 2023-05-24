//
//  UIColor+Random.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/24.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
