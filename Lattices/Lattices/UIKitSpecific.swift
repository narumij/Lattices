//
//  UIKitSpecific.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/18.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension CGPoint {
    init(_ size: CGSize ) {
        self.init()
        x = size.width
        y = size.width
    }
}

extension CGSize {
    public typealias Element = CGFloat
    var elements:[CGFloat]
    {
        return [width,height]
    }
    init(_ elements:[CGFloat]) {
        self.init()
        width  = elements[0]
        height = elements[1]
    }
    init( scalar: CGFloat ) {
        self.init()
        width = scalar
        height = scalar
    }
}

func ellipseImage( _ color: UIColor?, size: CGSize, margin: CGSize ) -> UIImage {
    if let color = color {

        let rect = CGRect( origin: CGPoint(margin),
                           size: size - (margin * CGSize(scalar:2)) )

        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()

        ctx?.setFillColor(color.cgColor)
        ctx?.fillEllipse(in: rect )
        ctx?.setStrokeColor(UIColor.black.cgColor )
        ctx?.strokeEllipse(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
    return UIImage()
}

func ColorImage( _ color: UIColor, size: CGSize ) -> UIImage {
    UIGraphicsBeginImageContext(size)
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.addRect(CGRect(origin: CGPoint.zero, size: size))
    ctx?.setFillColor(color.cgColor)
    ctx?.fillPath()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}




