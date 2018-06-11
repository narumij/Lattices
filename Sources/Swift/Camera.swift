//
//  Camera.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit
import simd

struct Sphere {
    var center: SCNVector3 = SCNVector3Zero
    var radius: CGFloat = 1.0
    init() {
    }
    init( center c: SCNVector3, radius r: CGFloat ) {
        center = c
        radius = r
    }
}

class CameraInitial {
    static var stdFov : Double = 50.0
    static var stdUsesOrthographic : Bool = true
    static var stdScaleRate = 1.0
    var sphere: Sphere
    var orientation: SCNQuaternion
    var usesOrthographic: Bool
    var fov : Double
    init() {
        sphere = Sphere()
        orientation = SCNQuaternion(0,0,0,1)
        usesOrthographic = CameraInitial.stdUsesOrthographic
        fov = CameraInitial.stdFov
    }
    // MARK: -
    var position: SCNVector3 {
        return position(fov)
    }
    var scale : Double {
        return Double(sphere.radius) * CameraInitial.stdScaleRate
    }
    // MARK: -
    fileprivate let initialVector: SCNVector3 = SCNVector3(0,0,1)
    fileprivate func initialDistance( _ fov: Double ) -> SCNFloat {
        var fov = fov
        if fov == 0 { fov = CameraInitial.stdFov }
//        return SCNFloat( sphere.radius ) / SCNFloat( tan( fov.toRadian * 0.5 ) )
        return SCNFloat( scale ) / SCNFloat( tan( fov.toRadian * 0.5 ) )
    }
    fileprivate func initialDistance() -> SCNFloat {
        return initialDistance( fov )
    }
    fileprivate func position( _ fov: Double ) -> SCNVector3 {
        return sphere.center + orientation * initialVector * SCNVector3( initialDistance( fov ) )
    }
}

struct CameraRig_t {
    // MARK: -
    var position: SCNVector3 = SCNVector3Zero
    var orientation: SCNQuaternion = SCNQuaternionIdentity
    var orthographicScale : Double = 1.0 {
        didSet {
            didSetOrthographicScale()
        }
    }
    var usesOrthographicProjection : Bool = true {
        didSet {
            didSetUsesOrthographicProjection()
        }
    }
    var orthScaleBegin = 1.0
    // MARK: -
    var bound: Sphere = Sphere() {
        didSet {
            rotationCenter = bound.center
        }
    }
    var rotationCenter : SCNVector3 = SCNVector3() {
        didSet {
            updateOrthographicScaleByActualDistance()
        }
    }
    var eyePoint: SCNVector3 {
        get { return position }
        set(eye) { position = eye }
    }
    var watchPoint: SCNVector3 {
        let a = eyePoint
        let b = orientation * SCNVector3( 0, 0, -1 ) + a
        return SCNVector3( closestPtLine( c: double3(bound.center), a: double3(a), b: double3(b) ) )
    }
    var actualDistance: Double {
        get { return simd.distance( double3(watchPoint), double3(eyePoint) ) }
        set(d) { eyePoint = SCNVector3( double3(watchPoint) + normalize( double3(eyePoint) - double3(watchPoint) ) * d ) }
    }
    var distance: Double {
        return usesOrthographicProjection ? orthographicScale : orthographicScale / tan( yFov.toRadian * 0.5 )
    }
    var yFov : Double = CameraInitial.stdFov {
        didSet {
            assert(yFov != 0.0)
            debugPrint("yfov = \(yFov)")
        }
    }
    // MARK: -
    mutating func updateOrthographicScale() {
        orthographicScale = usesOrthographicProjection ? orthographicScale : sin( yFov.toRadian * 0.5 ) * ( distance / cos( yFov.toRadian * 0.5 ) )
    }
    mutating func didSetUsesOrthographicProjection() {
        updateOrthographicScale()
    }
    mutating func didSetOrthographicScale() {
        actualDistance = usesOrthographicProjection ? Double(bound.radius) * 2.0 : orthographicScale / tan( yFov.toRadian * 0.5 )
    }
    mutating func updateOrthographicScaleByActualDistance() {
        orthographicScale = usesOrthographicProjection ? orthographicScale : sin( yFov.toRadian * 0.5 ) * ( actualDistance / cos( yFov.toRadian * 0.5 ) )
    }
    // MARK: -
    mutating func beginCameraScale() {
        orthScaleBegin = orthographicScale
    }
    mutating func endCameraScale() {
        orthScaleBegin = 1.0
    }
    mutating func scale(_ factor:Double) {
        let currentScale = max( 0.001, orthScaleBegin * 1.0 / factor )
        orthographicScale = currentScale
    }
    mutating func move( translate: Vector3, rotate: Vector3, factor: FloatType ) {
        let o = normalize(Lattices.orientation( rotate, factor: factor ))
        var t = Lattices.translate( translate, factor: factor )
        if usesOrthographicProjection {
            let scale = Float( orthographicScale )
            t = vector3( t.x * scale, t.y * scale, 0 )
        } else {
            let scale = Float( actualDistance * tan( yFov.toRadian / 2 ) )
            t = vector3( t.x * scale, t.y * scale, t.z * scale )
        }
        position = applyOrientation( position: position, orientation: orientation, center: rotationCenter, o: o )
        position = applyTransform( position: position, orientation: orientation, transform: SCNVector3(t) )
        orientation = normalize(orientation * o)
        updateOrthographicScaleByActualDistance()
    }
    mutating func rotate( orientation o: SCNQuaternion ) {
        let distance = simd.distance(Vector3(position),Vector3(rotationCenter))
        position = o * SCNVector3(vector3(0,0,1)*distance) + rotationCenter
        orientation = o
    }
}

class CameraScene_t {
    var rig: CameraRig_t = CameraRig_t()
    // MARK: -
    var sphere: Sphere = Sphere() {
        didSet {
            rig.bound = sphere
        }
    }
    func recoverSphere() {
        rig.rotationCenter = sphere.center
        rig.updateOrthographicScaleByActualDistance()
    }
    // MARK: -
    var initial = CameraInitial()
    func initialPosition() {
        rig.position          = initial.position
        rig.orientation       = initial.orientation
        rig.orthographicScale = initial.scale
    }
    // MARK: -
    let pointOfView = SCNNode()
    static let StdCameraNode = "SwiftCrystalStandardCameraNode"
    func cameraNode() -> SCNNode {
        pointOfView.position = initial.position
        pointOfView.orientation = initial.orientation
        pointOfView.name = CameraScene_t.StdCameraNode
        pointOfView.camera = SCNCamera()
        pointOfView.camera?.automaticallyAdjustsZRange = true
        pointOfView.camera?.yFov = CameraInitial.stdFov
        pointOfView.camera?.xFov = CameraInitial.stdFov
        pointOfView.camera?.usesOrthographicProjection = CameraInitial.stdUsesOrthographic
        pointOfView.camera?.orthographicScale = initial.scale
        return pointOfView
    }
    // MARK: -
    static let StdLightNode = "SwiftCrystalStandardLightNode"
    let _lightNode = SCNNode()
    func lightNode() -> SCNNode {
        _lightNode.name = CameraScene_t.StdLightNode

        let light = SCNLight()
        light.type = SCNLight.LightType.directional
        light.shadowColor = Color(white: 0.0, alpha: 0.4)
        light.castsShadow = true
        light.orthographicScale = CGFloat(initial.scale)

        _lightNode.light = light
        _lightNode.position = SCNVector3(0,0,-3)

        let ambientNode = SCNNode()
        let ambient = SCNLight()
        ambient.type = SCNLight.LightType.ambient
        ambient.color = Color(white: 0.1, alpha: 1.0)
        ambientNode.light = ambient
        ambientNode.name = "AmbientLightNode"

//        _lightNode.addChildNode(ambientNode)
        
        return _lightNode
    }
    var lightOrientation : SCNQuaternion {
        return SCNQuaternion( from: SCNVector3(0,0,1), to: SCNVector3(normalize(double3(0.25,1,1))) )
    }
    func commitLight() {
        let lightAction = SCNAction.run { (node:SCNNode) in
            node.position = applyOrientation( position: self.rig.position,
                                              orientation: self.rig.orientation,
                                              center: self.rig.rotationCenter,
                                              o: self.lightOrientation )
            node.orientation = self.rig.orientation * self.lightOrientation
        }
        _lightNode.runAction(lightAction)
    }
    // MARK: -
    var sceneController: AxisSceneController? = nil
    func commitAxis() {
        sceneController?.orientation = rig.orientation
    }
    // MARK: -
    var completionBlock: (()->Void)? = nil
    func refresh() {

        let action = SCNAction.run { ( node: SCNNode ) in
            node.position = self.rig.position
            node.orientation = self.rig.orientation
            node.camera?.automaticallyAdjustsZRange = true
            node.camera?.usesOrthographicProjection = self.rig.usesOrthographicProjection
            node.camera?.yFov = self.rig.yFov
            node.camera?.xFov = self.rig.yFov
            if self.rig.usesOrthographicProjection {
                node.camera?.orthographicScale = self.rig.orthographicScale
            }
        }

        action.duration = 0.0

        pointOfView.removeAllAnimations()
        pointOfView.removeAllActions()
        pointOfView.runAction(action)

        #if False
        pointOfView.position = rig.position
        pointOfView.orientation = rig.orientation
        pointOfView.camera?.automaticallyAdjustsZRange = true
        pointOfView.camera?.usesOrthographicProjection = rig.usesOrthographicProjection
        pointOfView.camera?.yFov = rig.yFov
        pointOfView.camera?.xFov = rig.yFov
        if rig.usesOrthographicProjection {
            pointOfView.camera?.orthographicScale = rig.orthographicScale
        }
        #endif

        commitLight()
        commitAxis()
        completionBlock?()
        endRotationCenter = rig.rotationCenter
    }

    var endRotationCenter = SCNVector3Zero

    func refreshAnimated() {

        pointOfView.removeAllActions()

        var temporaryRig = rig
        temporaryRig.position = pointOfView.presentation.position
        temporaryRig.orientation = pointOfView.presentation.orientation

        let startRotationCenter = temporaryRig.rotationCenter
        let startOrientation = temporaryRig.orientation
        let startDistance = temporaryRig.actualDistance

        let endPosition = rig.position
        let endOrientation = rig.orientation
        let endDistance = rig.actualDistance

        func mix( _ x : Double, _ y : Double, t : Double ) -> Double {
            return x * ( 1.0 - t ) + y * t
        }

        var values: [(SCNVector3,SCNQuaternion)] = []
        for i in 0..<10 {

            let d = mix( startDistance, endDistance, t: Double(i)/10 )
            temporaryRig.actualDistance = d

            let o = slerp( startOrientation, endOrientation, SCNFloat(i)/10 )
            temporaryRig.rotationCenter = SCNVector3( simd.mix(
                Vector3( startRotationCenter ),
                Vector3( endRotationCenter ),
                t: Vector3( FloatType(i) / 10.0 ) ) )
            temporaryRig.rotate( orientation: o )

            values.append( ( temporaryRig.position, temporaryRig.orientation ) )
        }
        values.append( (endPosition,endOrientation) )

//        rig.position = endPosition
//        rig.orientation = endOrientation
        rig.rotationCenter = endRotationCenter

        let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        let move = CAKeyframeAnimation(keyPath: "position")
        move.values = values.map{NSValue(scnVector3:$0.0)}
        move.duration = 0.5

        let rotate = CAKeyframeAnimation(keyPath: "orientation")
        rotate.values = values.map{NSValue(scnVector4:$0.1)}
        rotate.duration = 0.5

        let group = CAAnimationGroup()
        group.animations = [move,rotate]
        group.timingFunction = timingFunction
        group.duration = 0.5

        SCNTransaction.begin()
        SCNTransaction.setValue(true, forKey: kCATransactionDisableActions)
        pointOfView.position = endPosition
        pointOfView.orientation = endOrientation
        pointOfView.addAnimation( group, forKey: "refresh animated" )
        SCNTransaction.commit()

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.animationTimingFunction = timingFunction
        pointOfView.camera?.orthographicScale = rig.orthographicScale
        commitLight()
        commitAxis()
        SCNTransaction.commit()
    }

}

func applyOrientation(position: SCNVector3, orientation: SCNQuaternion, center: SCNVector3, o: SCNQuaternion ) -> SCNVector3 {
    return orientation * o * invert(orientation) * (position - center) + center
}

func applyTransform(position: SCNVector3, orientation: SCNQuaternion, transform: SCNVector3 ) -> SCNVector3 {
    return position + orientation * transform
}

func GetStdCameraNode( _ scene: SCNScene ) -> SCNNode? {
    return scene.rootNode.childNode(withName: CameraScene_t.StdCameraNode, recursively: true)
}

func GetStdLightNode( _ scene: SCNScene ) -> SCNNode? {
    return scene.rootNode.childNode(withName: CameraScene_t.StdLightNode, recursively: true)
}

// MARK: -

class CameraController: NSObject {
    unowned let view: SCNView
    unowned let crystal: SwiftCrystal

    var camera : CameraScene_t {
        return crystal.camera
    }

    init( view: SCNView, crystal: SwiftCrystal ) {
        self.view = view
        self.crystal = crystal
        super.init()
        debugPrint("yfov = \(camera.rig.yFov)")
        camera.refresh()
    }

    func toggleUsesOrthographicProjection() {
        camera.rig.usesOrthographicProjection = camera.rig.usesOrthographicProjection ? false : true
        camera.refresh()
    }

    fileprivate var pointOfView: SCNNode {
        return view.pointOfView ?? SCNNode()
    }

    func beginCameraScale() {
        camera.rig.beginCameraScale()
    }

    func endCameraScale() {
        camera.rig.endCameraScale()
    }

    func cameraScale(_ factor:Double) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0
        camera.rig.scale(factor)
        camera.refresh()
        SCNTransaction.commit()
    }

    func cameraMove( translate: Vector3, rotate: Vector3, factor: FloatType ) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0
        camera.rig.move(translate: translate, rotate: rotate, factor: factor)
        camera.refresh()
        SCNTransaction.commit()
    }

    func initialPosition() {
        camera.initialPosition()
        camera.endRotationCenter = camera.sphere.center
        camera.refreshAnimated()
    }

}


