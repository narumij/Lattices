//
//  AxisSceneController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class AxisSceneController: NSObject {

    fileprivate var contentsNode: SCNNode
    fileprivate var x: SCNNode
    fileprivate var y: SCNNode
    fileprivate var z: SCNNode
    fileprivate var aNode: SCNNode
    fileprivate var bNode: SCNNode
    fileprivate var cNode: SCNNode

    let up = SCNVector3(0,1,0)

    var cell: CrystalCell_t {
        get {
            return CrystalCell_t()
        }
        set( c ) {
            aVector = normalize(c.aVector)
            bVector = normalize(c.bVector)
            cVector = normalize(c.cVector)
        }
    }

    var aVector: Vector3 = Vector3( 1, 0, 0 )
        { didSet {
            x.orientation = SCNQuaternion( from: up, to: SCNVector3( aVector) )
        } }

    var bVector: Vector3 = Vector3( 0, 1, 0 )
        { didSet {
            y.orientation = SCNQuaternion( from: up, to: SCNVector3(bVector) )
        } }

    var cVector: Vector3 = Vector3( 0, 0, 1 )
        { didSet {
            z.orientation = SCNQuaternion( from: up, to: SCNVector3(cVector) )
        } }

    var orientation : SCNQuaternion = SCNQuaternion(0,0,0,1)
        {
        didSet {
            let coAction = SCNAction.run({ (node:SCNNode) in
                node.orientation = invert(self.orientation)
            })
            let aAction = SCNAction.run { (node:SCNNode) in
                node.orientation = self.orientation
                node.position = SCNVector3( self.aVector * 1.25 ) + self.orientation * self.offset( self.aVector, self.bVector, self.cVector, -1, -1 )
            }
            let bAction = SCNAction.run { (node:SCNNode) in
                node.orientation = self.orientation
                node.position = SCNVector3( self.bVector * 1.25 ) + self.orientation * self.offset( self.bVector, self.aVector, self.cVector, 1, 1 )
            }
            let cAction = SCNAction.run { (node:SCNNode) in
                node.orientation = self.orientation
                node.position = SCNVector3( self.cVector * 1.25 ) + self.orientation * self.offset( self.cVector, self.aVector, self.bVector, 1, -1 )
            }
            contentsNode.runAction(coAction)
            aNode.runAction(aAction)
            bNode.runAction(bAction)
            cNode.runAction(cAction)
        }
    }

    var invOrientation: SCNQuaternion {
        return invert(orientation)
    }

    let scene: SCNScene

    let pointOfView: SCNNode

    #if os(OSX)
    typealias Font = NSFont
    #elseif os(iOS)
    typealias Font = UIFont
    #endif

    override init() {

        func constant(_ diffuse:Color) -> SCNMaterial {
            let m = SCNMaterial()
            m.diffuse.contents = diffuse
            m.lightingModel = SCNMaterial.LightingModel.constant
            return m
        }

        func text(_ label:String,_ color:Color) -> SCNText {
            let a = SCNText(string: label, extrusionDepth: 0.0)
            a.containerFrame = CGRect(x: -0.125, y: -0.6, width: 0.5, height: 0.5)
            a.truncationMode = kCATruncationNone
            a.alignmentMode = kCAAlignmentCenter
            a.font = Font(name: "Courier", size: 0.5)
            a.firstMaterial = constant(color)
            return a
        }

        let thick:CGFloat = 0.025

        func arrow( _ color: Color ) -> SCNNode {
            let material = constant(color)
            let n0 = SCNNode(geometry:SCNCone( topRadius: 0, bottomRadius: thick*3, height: 0.5 ) )
            let n1 = SCNNode(geometry:SCNCylinder(radius: thick, height: 0.5))
            n0.geometry?.firstMaterial = material
            n1.geometry?.firstMaterial = material
            n0.position = SCNVector3(0,0.75,0)
            n1.position = SCNVector3(0,0.25,0)
            let n = SCNNode()
            n.addChildNode(n0)
            n.addChildNode(n1)
            return n
        }

        scene = SCNScene()
        contentsNode = SCNNode()
        let geometry = SCNSphere(radius: thick)
        geometry.firstMaterial = constant( Color.black )
        scene.rootNode.addChildNode( contentsNode )
        contentsNode.geometry = geometry

        x = arrow( Color.red )
        y = arrow( Color.green )
        z = arrow( Color.blue )

        aNode = SCNNode( geometry: text( "x", Color.black ) )
        bNode = SCNNode( geometry: text( "y", Color.black ) )
        cNode = SCNNode( geometry: text( "z", Color.black ) )

        contentsNode.addChildNode( x )
        contentsNode.addChildNode( y )
        contentsNode.addChildNode( z )

        contentsNode.addChildNode( aNode )
        contentsNode.addChildNode( bNode )
        contentsNode.addChildNode( cNode )

        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 1.5
        let cameraNode = SCNNode()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.camera = camera
        pointOfView = cameraNode
        cameraNode.position = SCNVector3(0,0,5)

        super.init()
    }

    func offset( _ aVector:Vector3,_ bVector:Vector3,_ cVector:Vector3,_ coeff0: FloatType,_ coeff1: FloatType ) -> SCNVector3 {

        let _0limit: FloatType = 0.4
        let veclimit: FloatType = 0.25

        let aPos = invOrientation * aVector
        let bPos = invOrientation * bVector
        let cPos = invOrientation * cVector
        var offset : Vector3 = vector3(0)

        let _0d = distance( Vector2(0), aPos.xy )
        if  _0d < _0limit
        {
            let ep = -normalize( bPos.xy + cPos.xy ) * (1/25)
            let v = normalize( aPos.xy + ep ) * ( _0limit - _0d )
            offset = vector3( v.x, v.y, 0 )
        }

        let bd = distance( bPos.xy, aPos.xy )
        if  bd < veclimit
        {
            let ep = coeff0*normalize( aPos.yx * Vector2(-1,1) ) * (1/25)
            let v = normalize( aPos.xy - bPos.xy + ep ) * ( veclimit - bd )
            offset = vector3( v.x, v.y, 0 )
        }

        let cd = distance( cPos.xy, aPos.xy )
        if  cd < veclimit
        {
            let ep = coeff1*normalize( aPos.yx * Vector2(-1,1) ) * (1/25)
            let v = normalize( aPos.xy - cPos.xy + ep ) * ( veclimit - cd )
            offset = vector3( v.x, v.y, 0 )
        }

        return SCNVector3( offset )
    }

}






