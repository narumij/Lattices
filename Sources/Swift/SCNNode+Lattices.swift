//
//  SCNNode+Lattices.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit


extension SCNNode {
    func addChild( _ block: (inout SCNNode)->Void ) {
        var node = SCNNode()
        block(&node)
        addChildNode(node)
    }
}


