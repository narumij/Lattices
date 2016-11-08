//
//  ScrollTextureLayer.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/27.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

var once : Int = 0



class ScrollTextureLayer: CALayer {
    /*
    private static var __once: () = {
            instance = ScrollTextureLayer()
            instance?.prepare(CGRect(x: 0, y: 0, width: 32, height: 32))
            instance?.start()
        }()
 */
    let layer0 : CALayer = CALayer()
    let layer1 : CALayer = CALayer()

    let frontColor : UIColor = UIColor.white

    func setup() {
        backgroundColor = UIColor.white.cgColor
        let color = UIColor(red: 0, green: 0.5, blue: 0, alpha: 1.0)
        layer0.backgroundColor = color.cgColor
        layer1.backgroundColor = color.cgColor
        addSublayer(layer0)
        addSublayer(layer1)
        masksToBounds = true
    }
    
    override init() {
        super.init()
        setup()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setup()
    }

    func prepare( _ bounds: CGRect ) {
        frame = bounds
        layer0.frame = bounds
        layer1.frame = bounds
        layer0.frame.size.width = layer0.frame.size.width * 0.5
        layer1.frame.size.width = layer0.frame.size.width
    }

    func start() {
        let anim0 = CABasicAnimation(keyPath: "position.x")
        anim0.fromValue = 0.0 + layer0.frame.width * 0.5
        anim0.toValue = frame.size.width + layer0.frame.width * 0.5
        anim0.duration = 1.0
        anim0.repeatCount = Float.infinity
        anim0.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim0.isRemovedOnCompletion = false
        layer0.add(anim0, forKey: "position.x")

        let anim1 = CABasicAnimation(keyPath: "position.x")
        anim1.fromValue = -frame.size.width + layer1.frame.width * 0.5
        anim1.toValue = 0.0 + layer1.frame.width * 0.5
        anim1.duration = anim0.duration
        anim1.repeatCount = anim0.repeatCount
        anim1.timingFunction = anim0.timingFunction
        anim1.isRemovedOnCompletion = false
        layer1.add(anim1, forKey: "position.x")
    }

    /*
    static var sharedInstance : ScrollTextureLayer? {
        let instance : ScrollTextureLayer? = nil
        _ = ScrollTextureLayer.__once
        return instance
    }
 */
    
}


