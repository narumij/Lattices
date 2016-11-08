//
//  TypeColorView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

@IBDesignable class TypeColorView: UIView {

    let shapeLayer = CAShapeLayer()

    func updatePath() {
        let path = CGMutablePath()
        path.addEllipse(in: shapeLayer.bounds)
        shapeLayer.path = path
    }

    func myInit() {
        shapeLayer.shadowOffset = CGSize( width: 0.5, height: 0.5 )
        shapeLayer.shadowOpacity = 0.5
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowRadius = 3.0
        shapeLayer.fillColor = color.cgColor
        shapeLayer.frame = bounds
        shapeLayer.anchorPoint = shapeLayer.bounds.center
        updatePath()
        layer.addSublayer(shapeLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        myInit()
        backgroundColor = UIColor.clear
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        myInit()
        backgroundColor = UIColor.clear
    }

    @IBInspectable var color : UIColor = UIColor.purple {
        didSet {
            shapeLayer.fillColor = color.cgColor
        }
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
    // Drawing code
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(UIColor.clear.cgColor)
        ctx?.fill(rect)
        #if TARGET_INTERFACE_BUILDER
            ctx?.addEllipse(in: bounds)
            ctx?.setFillColor(color.cgColor)
            ctx?.fillPath()
        #endif
    }

    override func layoutSubviews() {
        shapeLayer.frame = bounds
        updatePath()
    }

}


