//
//  OverlayViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class OverlayViewController: UIViewController {

    weak var crystal: SwiftCrystal?

    var overlayView: UIView? {
        get { return view }
        set(v) { view = v }
    }

    weak var sceneView: SCNView?

    func prepareOverlays() {
        _ = crystal?.sceneAtoms.map{
            view.layer.addSublayer($0.textLayer)
        }
        _ = crystal?.sceneBonds.map{
            view.layer.addSublayer($0.textLayer)
        }
//        debugPrint("\(crystal?.sceneBonds.map{$0.textLayer.string})")
    }

    func updateOverlayPositions() {
        if crystal?.labelMode == .nothing {
            return
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.0)
        if crystal?.labelMode == .bondDistance {
            _ = crystal?.sceneBonds.map{
                let position = Vector3($0.bond.center)
                let projectPoint = sceneView?.projectPoint(SCNVector3(position.x,position.y,position.z))
                $0.textLayer.position = CGPoint(
                    x: CGFloat( projectPoint?.x ?? 0 ),
                    y: CGFloat( projectPoint?.y ?? 0 ) )
//                $0.textLayer.position = overlayView!.bounds.center
                $0.textLayer.zPosition = 1 - CGFloat(projectPoint?.z ?? 0)
                let z = projectPoint?.z ?? 0
                if z <= 0 || 1 <= z {
                    $0.textLayer.position = CGPoint(x: -300, y: -300)
                }
                $0.textLayer.foregroundColor = UIColor.black.cgColor
//                $0.textLayer.backgroundColor = UIColor.clearColor().CGColor
            }
        }
        else {
            _ = crystal?.sceneAtoms.map{
                if $0.textLayer.isHidden {
                    return
                }
                let position = Vector3($0.node.position)
                let projectPoint = sceneView?.projectPoint(SCNVector3(position.x,position.y,position.z))
                $0.textLayer.position = CGPoint(
                    x: CGFloat( projectPoint?.x ?? 0 ),
                    y: CGFloat( projectPoint?.y ?? 0 ) )
                $0.textLayer.zPosition = 1 - CGFloat(projectPoint?.z ?? 0)
                let z = projectPoint?.z ?? 0
                if z <= 0 || 1 <= z {
                    $0.textLayer.position = CGPoint(x: -300, y: -300)
                }
            }
        }
        CATransaction.commit()
    }

}






