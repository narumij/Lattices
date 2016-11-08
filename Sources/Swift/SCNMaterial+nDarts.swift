//
//  SCNMaterial+nDarts.swift
//  nDarts
//
//  Created by Jun Narumi on 2016/09/21.
//  Copyright © 2016年 zenithgear Inc. All rights reserved.
//

import SceneKit

extension SCNMaterial {
    static var white: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.white
        return m
    }
    static var lightGray: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.lightGray
        return m
    }
    static var gray: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.gray
        return m
    }
    static var darkGray: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.darkGray
        return m
    }
    static var black: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.black
        return m
    }
    static var red: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.red
        return m
    }
    static var yellow: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.yellow
        return m
    }
    static var blue: SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = UIColor.blue
        return m
    }
}
