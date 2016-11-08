//
//  SwiftCrystal+OSX.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension SwiftCrystal {
    func bitmapImageRep(size:CGSize) -> NSBitmapImageRep {
        return bitmapImageRep_SCNView(size)
    }
    func bitmapImageRep_CGLContext(size:CGSize) -> NSBitmapImageRep {
        let renderer = OffscreenRendererLegacy();
        //        let renderer = OffscreenRenderer();
        renderer.scene = simpleScene
        let image = renderer.imageWithSize(size)
        let tiff = image.TIFFRepresentation
        let rep = NSBitmapImageRep.init(data: tiff!)
        return rep ?? NSBitmapImageRep()
    }
    func bitmapImageRep_SCNView(size:CGSize) -> NSBitmapImageRep {
        let frame = CGRect(origin: CGPoint(), size: size)
        //        let frame = CGRect(x: 0, y: 0, width: size.width*0.8, height: size.height)
        let sceneView = SCNView.init(frame: frame, options: [SCNPreferredRenderingAPIKey:(SCNRenderingAPI.OpenGLLegacy).rawValue as NSNumber])
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.0)
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = Color.redColor()
        sceneView.scene = simpleScene
        SCNTransaction.commit()
        SCNTransaction.flush()
        let image = sceneView.snapshot()
        let tiff = image.TIFFRepresentation
        let rep = NSBitmapImageRep.init(data: tiff!)
        return rep ?? NSBitmapImageRep()
    }
    var collada: String {
        let builder = CrystalCollada()
        let latticeColor = symopHasProblem ? SCNVector4(1,0,0,1) : SCNVector4(0.5,0.5,0.5,1)
        builder.addLines( cell.latticeLineVertices, emission: latticeColor, diffuse: SCNVector4(0,0,0,1) )
        builder.addLines( bondLineVertices, emission: SCNVector4(0.5,0.5,0.5,1), diffuse: SCNVector4(0.5,0.5,0.5,1) )
        for (size,posision,color) in atomTuples {
            builder.addSphere(size*radiiSize, pos: posision, color: color)
        }
        return builder.collada
    }
    var colladaData: NSData? {
        return (collada as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    }
}

