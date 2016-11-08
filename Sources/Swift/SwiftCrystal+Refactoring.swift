//
//  SwiftCrystal+Refactoring.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension SwiftCrystal {
    #if false
    func bondLines() -> SCNGeometry {
    switch bondingMode {
    //        case .GrayLine:
    //            fallthrough
    case .GrayCylindar:
    let g = SCNGeometry.lines(bondLineVertices)
    g.materials = [lineMaterial()]
    return g
    default:
    var bondVertices : [SCNVector3] = []
    var bondColors : [SCNVector4] = []
    for bond in bonds {
    let c1 = bondColorVector(bond.atom1)
    let c2 = bondColorVector(bond.atom2)
    bondVertices.append(SCNVector3(bond.cartnCoord1.pos))
    bondColors.append(c1)
    bondVertices.append(SCNVector3((bond.cartnCoord1.pos + bond.cartnCoord2.pos) * 0.5))
    bondColors.append(c1)
    bondVertices.append(SCNVector3((bond.cartnCoord1.pos + bond.cartnCoord2.pos) * 0.5))
    bondColors.append(c2)
    bondVertices.append(SCNVector3(bond.cartnCoord2.pos))
    bondColors.append(c2)
    }
    return SCNGeometry.lines(bondVertices, colors:bondColors)
    }
    }
    #endif

    #if false
    func atomPoints() -> SCNGeometry {
    var vertices : [float3] = []
    var colors : [SCNVector4] = []
    for (_,p,c) in atomTuples {
    vertices.append(Vector3(p))
    colors.append(c)
    }
    #if false
    return SCNGeometry.points(vertices, colors: colors)
    #else
    let g = SCNGeometry.points(vertices)
    g.firstMaterial = SCNMaterial()
    g.firstMaterial?.ambient.contents = Color.black
    g.firstMaterial?.specular.contents = Color.black
    g.firstMaterial?.diffuse.contents = Color.black
    return g
    #endif
    }
    #endif

    func wyckoffPoints() -> SCNGeometry {
        let vertices: [float3] = wyckoffPositions().map{info.cell.toCartn(fract: $0)}
        return SCNGeometry.points(vertices)
    }
}

