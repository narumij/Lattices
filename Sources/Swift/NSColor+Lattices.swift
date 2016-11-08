//
//  NSColorExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

typealias Color = NSColor

extension Color {
    convenience init( white: CGFloat, alpha: CGFloat ) {
        self.init( calibratedWhite: white, alpha: alpha )
    }
    convenience init( red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat ) {
        self.init( calibratedRed: red, green: green, blue: blue, alpha: alpha )
    }
    convenience init( rgb: Vector3, alpha: CGFloat ) {
        self.init( calibratedRed: CGFloat(rgb.x), green: CGFloat(rgb.y), blue: CGFloat(rgb.z), alpha: alpha )
    }
    convenience init( rgba: Vector4 ) {
        self.init( calibratedRed: CGFloat(rgba.x), green: CGFloat(rgba.y), blue: CGFloat(rgba.z), alpha: CGFloat(rgba.w) )
    }
}

