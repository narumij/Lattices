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
        var v : [ CGFloat ] = [ 0, 0, 0, 0 ]
        getRed( &v[0], green: &v[1], blue: &v[2], alpha: &v[3] )
        return SCNVector4( v[0], v[1], v[2], v[3] )
    }
}

