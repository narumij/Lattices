//
//  CrystalCell+Lines.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation


extension CrystalCell_t {
    //    var latticeLineVertices: [SCNVector3] {
    //        var vertices : [SCNVector3] = []
    //        let a = SCNVector3(aVector)
    //        let b = SCNVector3(bVector)
    //        let c = SCNVector3(cVector)
    //        vertices.append(SCNVector3Zero)
    //        vertices.append(a)
    //        vertices.append(a)
    //        vertices.append(a+b)
    //        vertices.append(a+b)
    //        vertices.append(b)
    //        vertices.append(b)
    //        vertices.append(SCNVector3Zero)
    //        vertices.append(c)
    //        vertices.append(c+a)
    //        vertices.append(c+a)
    //        vertices.append(c+a+b)
    //        vertices.append(c+a+b)
    //        vertices.append(c+b)
    //        vertices.append(c+b)
    //        vertices.append(c)
    //        vertices.append(SCNVector3Zero)
    //        vertices.append(c)
    //        vertices.append(a+b)
    //        vertices.append(c+a+b)
    //        vertices.append(b)
    //        vertices.append(c+b)
    //        vertices.append(a)
    //        vertices.append(c+a)
    //        return vertices
    //    }
    var latticeLineVertices: (position:[float3],texcoord:[float2]) {
        var positions : [float3] = []
        var texcoords : [float2] = []

        let o = float3()
        let a = (aVector)
        let b = (bVector)
        let c = (cVector)

        let aa = length(aVector) * 5
        let bb = length(bVector) * 5
        let cc = length(cVector) * 5

        func append( _ vert : float3, _ tex : float2 ) {
            positions.append(vert)
            texcoords.append(tex)
        }

        append(o,float2(x:0,y:0))
        append(a,float2(x:aa,y:0))

        append(a,float2(x:0,y:0))
        append(a+b,float2(x:bb,y:0))

        append(a+b,float2(x:aa,y:0))
        append(b,float2(x:0,y:0))

        append(b,float2(x:bb,y:0))
        append(o,float2(x:0,y:0))

        append(c,float2(x:0,y:0))
        append(c+a,float2(x:aa,y:0))

        append(c+a,float2(x:0,y:0))
        append(c+a+b,float2(x:bb,y:0))

        append(c+a+b,float2(x:bb,y:0))
        append(c+b,float2(x:0,y:0))

        append(c+b,float2(x:bb,y:0))
        append(c,float2(x:0,y:0))

        append(o,float2(x:0,y:0))
        append(c,float2(x:cc,y:0))

        append(a+b,float2(x:0,y:0))
        append(c+a+b,float2(x:cc,y:0))
        
        append(b,float2(x:0,y:0))
        append(c+b,float2(x:cc,y:0))
        
        append(a,float2(x:0,y:0))
        append(c+a,float2(x:cc,y:0))
        
        return (position:positions,texcoord:texcoords)
    }
    
}


