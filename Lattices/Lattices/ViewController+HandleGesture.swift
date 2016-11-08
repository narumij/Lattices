//
//  ViewController+HandleGesture.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import SceneKit

extension ViewController {

    func resetRecognizer() {
        singleTapGestureRecognizer.isEnabled = true
        singlePanGestureRecognizer.isEnabled = true
        orthTapGestureRecognizer.isEnabled = true
    }

    func disableSomeRecognizers() {
        singleTapGestureRecognizer.cancelsTouchesInView = true
        singleTapGestureRecognizer.isEnabled = false
        singlePanGestureRecognizer.cancelsTouchesInView = true
        singlePanGestureRecognizer.isEnabled = false
        //        orthTapGestureRecognizer.cancelsTouchesInView = true
        //        orthTapGestureRecognizer.enabled = false
        disableTapGesture()
    }

    func disableTapGesture(_ time:CFAbsoluteTime) {
        //        debugPrint("disable reset tap gesture")
        tapGestureDisableTimeOut = CFAbsoluteTimeGetCurrent() + time
        resetTapGestureRecognizer.cancelsTouchesInView = true
        resetTapGestureRecognizer.isEnabled = false
        orthTapGestureRecognizer.cancelsTouchesInView = true
        orthTapGestureRecognizer.isEnabled = false
    }

    func disableTapGesture() {
        disableTapGesture(0.28)
    }

    func isDisableResetTapGesture() -> Bool {
        return !(tapGestureDisableTimeOut < CFAbsoluteTimeGetCurrent())
    }

    func momentum() {
        assert(Thread.isMainThread)
        if hasRotateXYMomentum {
            cameraLock.tryBlock { [weak self] in
                if let _self = self {
                    _self.cameraController?
                        .cameraMove(
                            translate: Vector3Zero,
                            rotate: Vector3( -_self.rotateXYVelocity.y, -_self.rotateXYVelocity.x, 0 ),
                            factor: 0.01 )
                }
            }
            rotateXYVelocity = rotateXYVelocity * 0.95
            if length(rotateXYVelocity) < 0.1 {
                rotateXYVelocity = Vector2(0)
                hasRotateXYMomentum = false
            }
        }
        if hasTranslateMomentum {
            cameraLock.tryBlock { [weak self] in
                if let _self = self {
                    _self.cameraController?
                        .cameraMove(
                            translate: Vector3( -_self.translateVelocity.x, _self.translateVelocity.y, 0 ),
                            rotate: Vector3Zero,
                            factor: 1.0 )
                }
            }
            translateVelocity = translateVelocity * 0.8
            if length(translateVelocity) < 0.01 {
                translateVelocity = Vector2(0)
                hasTranslateMomentum = false
            }
        }
        //        if resetTapGestureRecognizer.enabled == false && resetTapGestureDisableTimeOut < CFAbsoluteTimeGetCurrent() {
        //            debugPrint("time out!")
        //        }
        resetTapGestureRecognizer.isEnabled = tapGestureDisableTimeOut < CFAbsoluteTimeGetCurrent()
        orthTapGestureRecognizer.isEnabled = tapGestureDisableTimeOut < CFAbsoluteTimeGetCurrent()
    }

    func stopMomentum() {
        hasRotateXYMomentum = false
        hasTranslateMomentum = false
    }

    @IBAction func singlePanAction(_ sender: UIPanGestureRecognizer ) {
        let diff = sender.location(in: sceneView) - lastPan
        lastPan = sender.location(in: sceneView)
        if sender.state != .began {
            stopMomentum()
            disableTapGesture()
            cameraLock.syncBlock { [weak self] in
                self?.cameraController?
                    .cameraMove(
                        translate: Vector3Zero,
                        rotate: Vector3( -Float(diff.y), -Float(diff.x), 0 ),
                        factor: 0.01 )
            }
        }
        if sender.state == .ended {
            var v = sender.velocity(in: sceneView)
            v.x = v.x * (2 / 60)
            v.y = v.y * (2 / 60)
            rotateXYVelocity = Vector2( FloatType(v.x), FloatType(v.y) )
            if length(rotateXYVelocity) > 7 {
                hasRotateXYMomentum = true
            }
            document?.updateChangeCount(.done)
        }
    }
    @IBAction func doublePanAction( _ sender: UIPanGestureRecognizer ) {

        var diff = sender.location(in: sceneView) - lastDoublePan
        let s = min( sceneView.frame.size.width, sceneView.frame.size.height ) / 2.0
        diff.x = diff.x / s
        diff.y = diff.y / s
        lastDoublePan = sender.location(in: sceneView)

        if sender.state == .ended {
            //            debugPrint("end")
            if isActiveDoublePan {
                resetRecognizer()
                var v = sender.velocity(in: sceneView)
                v.x = v.x * (2 / 60)
                v.y = v.y * (2 / 60)
                translateVelocity = Vector2( FloatType(v.x), FloatType(v.y) )
                if length(translateVelocity) > 50 {
                    let limit: FloatType = 3/60.0
                    translateVelocity = normalize(translateVelocity) * limit
                    hasTranslateMomentum = true
                }
                updateCenter()
                document?.updateChangeCount(.done)
            }
            isActiveDoublePan = false
            return
        }

        if sender.state == .began {
            //            debugPrint("began")
            stopMomentum()
            disableTapGesture()
        }
        //        if sender.numberOfTouches() < 2 { return }
        //        disableSomeRecognizers()

        let lastTouches = lastDoubleTapGestureTouches
        lastDoubleTapGestureTouches = sender.numberOfTouches
        if lastTouches < 2 || lastDoubleTapGestureTouches < 2 {
            //指が一本から二本に増えただけのときはワープするから、動かさない
            //二本から一本に減ったときも同様
            return
        }

        disableSomeRecognizers()

        if sender.state != .began {
            isActiveDoublePan = true
            cameraLock.syncBlock{ [weak self] in
                self?.cameraController?
                    .cameraMove(
                        translate: vector3( -Float(diff.x), Float(diff.y), 0 ),
                        rotate: Vector3Zero,
                        factor: 1.0 )
            }
        }
    }
    
    @IBAction func rotationAction( _ sender: UIRotationGestureRecognizer ) {
        let diff = sender.rotation - lastRotate
        lastRotate = sender.rotation
        if sender.state != .began {
            stopMomentum()
            disableTapGesture()
            cameraLock.syncBlock{ [weak self] in
                self?.cameraController?
                    .cameraMove(
                        translate: Vector3Zero,
                        rotate: vector3(0,0,Float(diff)),
                        factor: 1 )
            }
        }
        if sender.state == .ended {
            resetRecognizer()
            document?.updateChangeCount(.done)
        }
    }

    @IBAction func pinchAction( _ sender: UIPinchGestureRecognizer ) {
        if sender.state == .began {
            stopMomentum()
            disableTapGesture()
            cameraController?.beginCameraScale()
        }
        if sender.state != .began {
            cameraLock.syncBlock{ [weak self] in
                self?.cameraController?.cameraScale( Double( sender.scale ) )
            }
        }
        if abs( sender.scale - 1.0 ) > 0.05 {
            disableSomeRecognizers()
        }
        if sender.state == .ended {
            cameraController?.endCameraScale()
            resetRecognizer()
            updateCenter()
            document?.updateChangeCount(.done)
        }
    }

    @IBAction func earlyPress( _ sender: UILongPressGestureRecognizer ) {
        if sender.state == .began {
            stopMomentum()
            resetRecognizer()
            if isDisableResetTapGesture() { disableTapGesture() }
            document?.updateChangeCount(.done)
        }
        //        print("early press \(sender)")
    }

    @IBAction func singleTapAction( _ sender: UITapGestureRecognizer ) {
    }

    @IBAction func tapAction( _ sender: UITapGestureRecognizer ) {
        assert(sender === orthTapGestureRecognizer)
        cameraLock.syncBlock {
            [weak self] in
            //            self?.cameraController?.usesOrthographicProjection = self?.cameraController?.usesOrthographicProjection ?? false ? false : true
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0
            SCNTransaction.completionBlock = {
                self?.updateCenter()
                //                self?.overlayViewController.updateOverlayPositions()
            }
            self?.cameraController?.toggleUsesOrthographicProjection()
            SCNTransaction.commit()
            self?.document?.updateChangeCount(.done)
        }
    }

    @IBAction func tripleTapAction( _ sender: UITapGestureRecognizer ) { // 実際はダブルタップ
        assert(sender === resetTapGestureRecognizer)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.5
        SCNTransaction.completionBlock = {
            self.updateCenter()
            //            self.overlayViewController.updateOverlayPositions()
        }
        cameraLock.syncBlock {
            [weak self] in
            self?.stopMomentum()
            self?.cameraController?.initialPosition()
            self?.document?.updateChangeCount(.done)
        }
        SCNTransaction.commit()
    }

    func gestureRecognizer( _ gestureRecognizer: UIGestureRecognizer,
                            shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.delegate !== self {
            return false
        }
        return true
    }
    

}
