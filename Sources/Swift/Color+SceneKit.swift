//
//  UIColor(SceneKit).swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension Color {
    var vector4 : SCNVector4 {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        getRed( &r, green: &g, blue: &b, alpha: &a )
        return SCNVector4( r, g, b, a )
    }
}

