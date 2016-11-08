//
//  CrystalScene.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class CrystalScene {

    var nodes : [SCNNode] = []

    init() {
    }

    func addLines( _ positions:[float3],emission:SCNVector4,diffuse:SCNVector4,castsShadow:Bool) {
        let node = SCNNode()
        let material = SCNMaterial()
        material.emission.contents = Color( rgba: Vector4(emission) )
        material.diffuse.contents = Color( rgba: Vector4(diffuse) )
        node.geometry = SCNGeometry.lines( positions )
        node.geometry?.materials = [material]
        node.castsShadow = castsShadow
        nodes.append(node)
    }

    func addSphere(_ size:RadiiSizeType,pos:SCNVector3,color:SCNVector4) {
        let node0 = SCNNode()
        let node1 = SCNNode()
        let material = SCNMaterial()
        material.emission.contents = Color( white: 0.0, alpha: 1.0 )
        material.diffuse.contents = Color( rgba: Vector4(color) )
        node1.geometry = SCNSphere(radius: 1.0)
        node1.geometry?.materials = [material]
        node1.scale = SCNVector3(size,size,size)
        node0.addChildNode(node1)
        node0.position = pos
        nodes.append(node0)
    }

    var scene: SCNScene {
        let scene = SCNScene()
        for node in nodes {
            scene.rootNode.addChildNode(node)
        }
        return scene
    }
}



