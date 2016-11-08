//
//  SwiftCrystal+SimpleScene.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension SwiftCrystal {

    fileprivate var bondLineVertices: [float3] {
        var bondVertices : [float3] = []
        for bond in concrete.bonds {
            bondVertices.append(bond.cartn1)
            bondVertices.append(bond.cartn2)
        }
        return bondVertices
    }

    fileprivate var atomTuples: [(RadiiSizeType,SCNVector3,SCNVector4)] {
        return concrete.atoms.map{
            let position = SCNVector3($0.cartn)
            let radius = self.radiiType.radius( $0.atomicSymbol )
            let color = self.colors.colorVector( $0.atomicSymbol )
            return (radius,position,SCNVector4(color.x,color.y,color.z,1))
        }
    }

    var simpleScene: SCNScene {
        let builder = CrystalScene()
        let latticeColor = info.symopHasProblem ? SCNVector4(1,0,0,1) : SCNVector4(0.5,0.5,0.5,1)
        builder.addLines( info.cell.latticeLineVertices.position, emission: latticeColor, diffuse: SCNVector4(0,0,0,1), castsShadow:  false )
        builder.addLines( bondLineVertices, emission: SCNVector4(0.5,0.5,0.5,1), diffuse: SCNVector4(0,0,0,1), castsShadow:  true )
        for (size,posision,color) in atomTuples {
            builder.addSphere(size*radiiSize, pos: posision, color: color)
        }
        return builder.scene
    }
    
}

