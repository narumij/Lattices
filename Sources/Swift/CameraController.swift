//
//  CameraController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class CameraController: NSObject {

    unowned let view: SCNView
    unowned let crystal: SwiftCrystal

    var orthScaleBegin = 1.0

    init( view: SCNView, crystal: SwiftCrystal ) {
        self.view = view
        self.crystal = crystal
        super.init()
//        cameraInitial()
        cameraRefresh()
        commitAxis()
    }

    var center : SCNVector3 {
        return crystal.center
    }

    var position : SCNVector3 {
        get {
            return crystal.cameraPosition
        }
        set(p) {
            crystal.cameraPosition = p
            didSetPosition()
        }
    }

    var orientation : SCNQuaternion {
        get {
            return crystal.cameraOrientation
        }
        set (o) {
            crystal.cameraOrientation = o
            didSetOrientation()
        }
    }

    var usesOrthographicProjection : Bool {
        get {
            return crystal.cameraUsesOrthographicProjection
        }
        set( flag ) {
            crystal.cameraUsesOrthographicProjection = flag
            didSetUsesOrthographicProjection()
        }
    }

    var orthographicScale : Double {
        get {
            return crystal.cameraOrthographicScale
        }
        set (o) {
            crystal.cameraOrthographicScale = o
            didSetOrthographicScale()
        }
    }

    func initialPosition() -> SCNVector3 {
        return SharedAppDelegate().currentDocument!.crystal.initialPosition()
    }

    var initialOrientation: SCNQuaternion {
        return SharedAppDelegate().currentDocument!.crystal.initialOrientation
    }

    var initialScale : Double {
        return SharedAppDelegate().currentDocument!.crystal.initialScale
    }

    private var pointOfView: SCNNode {
        return view.pointOfView ?? SCNNode()
    }

    func didSetPosition() {
        view.pointOfView?.position = position
    }

    func didSetOrientation() {
        view.pointOfView?.orientation = orientation
    }

    func didSetUsesOrthographicProjection() {
        pointOfView.camera?.usesOrthographicProjection = usesOrthographicProjection
        updateOrthographicScale()
    }

    func didSetOrthographicScale() {
        pointOfView.camera?.orthographicScale = orthographicScale
        actualCameraDistance = usesOrthographicProjection ? initialScale * 2.0 : orthographicScale / tan( yFov.toRadian * 0.5 )
        pointOfView.camera?.yFov = yFov
        pointOfView.camera?.xFov = yFov
    }

    var eyePoint: SCNVector3 {
        get { return position }
        set(eye) { position = eye }
    }

    var watchPoint: SCNVector3 {
        let a = eyePoint
        let b = orientation * SCNVector3( 0, 0, -1 ) + a
        return SCNVector3( closestPtLine( c: double3(center), a: double3(a), b: double3(b) ) )
    }

    private func updateOrthographicScale() {
        orthographicScale = usesOrthographicProjection ? orthographicScale : sin( yFov.toRadian * 0.5 ) * ( cameraDistance / cos( yFov.toRadian * 0.5 ) )
    }

    var actualCameraDistance: Double {
        get { return distance( double3(watchPoint), double3(eyePoint) ) }
        set(d) { eyePoint = SCNVector3( double3(watchPoint) + normalize( double3(eyePoint) - double3(watchPoint) ) * d ) }
    }

    var cameraDistance: Double {
        return usesOrthographicProjection ? orthographicScale : orthographicScale / tan( yFov.toRadian * 0.5 )
    }

    var yFov : Double = SwiftCrystal.stdFov {
        didSet { assert(yFov != 0.0) }
    }

    func beginCameraScale() {
        orthScaleBegin = orthographicScale
    }

    func endCameraScale() {
        orthScaleBegin = 1.0
    }

    func cameraScale(factor:Double) {
        let currentScale = max( 0.001, orthScaleBegin * 1.0 / factor )
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0)
        orthographicScale = currentScale
        SCNTransaction.commit()
        commitLight()
        commitAxis()
    }

    func cameraMove( translate: Vector3, rotate: Vector3, factor: FloatType ) {
        let o = normalize(Lattices.orientation( rotate, factor: factor ))
        var t = Lattices.translate( translate, factor: factor )
        if usesOrthographicProjection {
            let scale = Float( orthographicScale )
            t = vector3( t.x * scale, t.y * scale, 0 )
        } else {
            let scale = Float( actualCameraDistance * tan( yFov.toRadian / 2 ) )
            t = vector3( t.x * scale, t.y * scale, t.z * scale )
        }
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0)
        position = applyOrientation( position: position, orientation: orientation, center: center, o: o )
        position = applyTransform( position: position, orientation: orientation, transform: SCNVector3(t) )
        orientation = normalize(orientation * o)
        SCNTransaction.commit()
        commitLight()
        commitAxis()
    }

    func cameraRefresh() {
        pointOfView.camera?.automaticallyAdjustsZRange = true
        didSetPosition()
        didSetOrientation()
        didSetOrthographicScale()
        didSetUsesOrthographicProjection()
        commitLight()
        commitAxis()
    }

    func cameraInitial() {
        pointOfView.camera?.automaticallyAdjustsZRange = true
        position          = initialPosition()
        orientation       = initialOrientation
        orthographicScale = initialScale
        commitLight()
        commitAxis()
    }

    var sceneController: AxisSceneController {
        return crystal.axisSceneController
    }

    func commitAxis() {
        sceneController.orientation = orientation
    }

    var lightOrientation : SCNQuaternion {
        return SCNQuaternion( from: SCNVector3(0,0,1), to: SCNVector3(normalize(double3(0.25,1,1))) )
    }

    func commitLight() {
        if let scene = view.scene {
            let lightNode = scene.rootNode.childNodeWithName(SwiftCrystal.StdLightNode, recursively: true)
//            assert( lightNode?.light != nil )
            lightNode?.position = applyOrientation( position: position, orientation: orientation, center: center, o: lightOrientation )
            lightNode?.orientation = orientation * lightOrientation
        }
    }

    enum DirectionType : Int {
        case Initial,d100,d010,d001,d111,n100,n010,n001,n111
    }

    func orientationFor( mode: DirectionType ) -> SCNQuaternion {
        let fromVec = SCNVector3(0,0,1)
        let cell = crystal.cell

        switch mode {
        case .d100:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.direction100) )
        case .d010:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.direction010) )
        case .d001:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.direction001) )
        case .d111:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.direction111) )
        case .n100:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.normal100) )
        case .n010:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.normal010) )
        case .n001:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.normal001) )
        case .n111:
            return SCNQuaternion( from: fromVec, to: SCNVector3(cell.normal111) )
        default:
            return SCNQuaternionIdentity
        }

    }

    func cameraOrientation( mode: DirectionType ) {
    }
}


















