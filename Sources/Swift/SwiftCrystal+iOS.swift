//
//  SwiftCrystal+iOS.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension SwiftCrystal {
    func image(_ size:CGSize) -> UIImage {
        let frame = CGRect( origin: CGPoint(), size: size )
        let sceneView = SCNView( frame: frame, options: [:] )
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = Color.white
        sceneView.scene = simpleScene
        //        sceneView.scene?.rootNode.addChildNode( newCameraNode() )
        SCNTransaction.commit()
        SCNTransaction.flush()
        return sceneView.snapshot()
    }

    func currentThumnail(_ size:CGSize) ->UIImage {
        SCNTransaction.flush()
        let frame = CGRect( origin: CGPoint(), size: size )
        let sceneView = SCNView( frame: frame, options: [:] )
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = Color.white
        sceneView.scene = scene
        return sceneView.snapshot()
    }
}

