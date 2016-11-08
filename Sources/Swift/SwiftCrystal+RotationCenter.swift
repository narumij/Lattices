//
//  SwiftCrystal+RotationCenter.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import SceneKit

extension SwiftCrystal {

    // MARK: -

    var initialSphere: Sphere {
        get {
            return camera.initial.sphere
        }
        set (s) {
            camera.initial.sphere = s
        }
    }

    var currentShere: Sphere {
        get {
            return camera.sphere
        }
        set (s) {
            camera.sphere = s
        }
    }

    func updateCenterOfGravityWithCalculate() {
        var radius: CGFloat = 0
        var center = SCNVector3Zero
        contentsNode.__getBoundingSphereCenter( &center, radius: &radius )
        let cellCenter = info.cell.cartnCenter
        let diff = distance(Vector3(center),cellCenter)
        center = SCNVector3( info.cell.cartnCenter )
        radius += CGFloat(diff)
        initialSphere = Sphere( center:center, radius:radius )
        currentShere = Sphere( center:center, radius:radius )
    }

    func updateCenterOfGravityWithContents() {
        if all(sceneAtoms.map{$0.hidden}) {
            updateCenterOfGravityWithCalculate()
            return
        }
        var radius: CGFloat = 0
        var center = SCNVector3Zero
        contentsNode.__getBoundingSphereCenter( &center, radius: &radius )
        initialSphere = Sphere( center:center, radius:radius )
        currentShere = Sphere( center:center, radius:radius )
    }

    func updateCenterOfGravityWithCrystal() {
        if all(sceneAtoms.map{$0.hidden}) {
            updateCenterOfGravityWithCalculate()
            return
        }
        var radius: CGFloat = 0
        var center = SCNVector3Zero
        crystalNode.__getBoundingSphereCenter( &center, radius: &radius )
        initialSphere = Sphere( center:center, radius:radius )
        currentShere = Sphere( center:center, radius:radius )
    }

    func updateCenterOfGravity() {
        switch bondingRangeMode {
        case .Grouping:
            updateCenterOfGravityWithCrystal()
        default:
            updateCenterOfGravityWithCalculate()
        }
    }

    // MARK: -

    func updateCenterNode(_ position:SCNVector3) {
        #if false
        if centerNode.parent == nil {
            contentsNode.addChildNode(centerNode)
            centerNode.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.1)
            centerNode.geometry?.firstMaterial = SCNMaterial()
        }
        centerNode.position = position
        #endif
    }

    func redCenterNode() {
        centerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
    }

    func yellowCenterNode() {
        centerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
    }

    func blueCenterNode() {
        centerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
    }

    func centerHoge( _ contents: AnyObject? ) {
        centerNode.geometry?.firstMaterial?.diffuse.contents = contents
    }

    func updateCenterWith( _ renderer: SCNView ) {
        debugPrint("center change")
        let viewCenter = renderer.bounds.center
        let nearCenter = renderer.unprojectPoint(SCNVector3(viewCenter.x,viewCenter.y,0))
        let farCenter = renderer.unprojectPoint(SCNVector3(viewCenter.x,viewCenter.y,1))
        let line = (a:Vector3(nearCenter),b:Vector3(farCenter))
        var point = Vector3Zero

        let hitTestResult = renderer.hitTest(viewCenter, options: [SCNHitTestOption.sortResults:true,SCNHitTestOption.ignoreHiddenNodes:true])
        if let first = hitTestResult.filter({ ($0.node.geometry as? SCNSphere) != nil || ($0.node.geometry as? SCNCylinder) != nil }).first {
            //        if let first = hitTestResult.filter({ ($0.node.geometry as? SCNCylinder) != nil }).first {
            //            debugPrint("hit result \(first.node.parentNode?.name)")
            //            debugPrint("hit result \(first.node.parentNode?.parentNode?.name)")
            //            debugPrint("hit result \(first.node.parentNode?.parentNode?.parentNode?.name)")
            //            debugPrint("hit result \(first.node.parentNode?.position)")
            if ( first.node.geometry as? SCNSphere) != nil  {
                point = Vector3(first.node.parent?.parent?.parent?.position ?? SCNVector3Zero)
            }
            else {
                point = Vector3(first.node.parent?.position ?? SCNVector3Zero)
            }
            //            centerHoge(first.node.geometry?.firstMaterial?.diffuse.contents ?? nil)
        }
        else {
            let activeAtoms = sceneAtoms.filter{ !$0.hidden }
            let distanceAndPosition : [(distance:FloatType,t:FloatType,point:Vector3)] = activeAtoms.map({
                let position = Vector3($0.node.position)
                var t : FloatType = 0
                var point = Vector3Zero
                closestPtLine(point:position,line:line,t:&t,d:&point)
                return (distance:distance(position,point),t:t,point:point)
            })
            let sorted = distanceAndPosition.filter({ 0 <= $0.t && $0.t <= 1 }).sorted(by: { $0.distance < $1.distance })
            let count = sorted.count < 12 ? sorted.count / 2 : 12
            if count == 0 {
                camera.recoverSphere()
                camera.refresh()

                redCenterNode()
                updateCenterNode( camera.rig.rotationCenter )
                return
            }
            for i in 0..<count {
                point += sorted[i].point
            }
            point /= Vector3(count)
        }
        point = closestPtLine(point:point,line:line)
        camera.rig.rotationCenter = SCNVector3(point)
        camera.refresh()

        blueCenterNode()
        updateCenterNode( camera.rig.rotationCenter )
    }

    func recoverCenter() {
        debugPrint("recover center")
        camera.recoverSphere()
        camera.refresh()

        redCenterNode()
        updateCenterNode( camera.rig.rotationCenter )
    }

}

