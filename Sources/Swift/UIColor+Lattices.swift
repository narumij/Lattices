//
//  UIColorExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

typealias Color = UIColor

extension Color {
    convenience init( rgb:Vector3, alpha: Float ) {
        self.init( red: CGFloat(rgb.x), green: CGFloat(rgb.y), blue: CGFloat(rgb.z), alpha: CGFloat(alpha) )
    }
    convenience init( rgba: Vector4 ) {
        self.init( red: CGFloat(rgba.x), green: CGFloat(rgba.y), blue: CGFloat(rgba.z), alpha: CGFloat(rgba.w) )
    }
}

