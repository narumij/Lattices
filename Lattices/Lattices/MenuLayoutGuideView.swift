//
//  MenuLayoutGuideView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/02.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

@IBDesignable
class MenuLayoutGuideView: UIView {

    #if false
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        backgroundColor?.setFill()
        UIBezierPath(rect: rect).fill()

        UIColor.redColor().setStroke()
        let bezier = UIBezierPath()

        func verticalLine( x: CGFloat ) {
            bezier.moveToPoint(CGPoint(x:x,y:0))
            bezier.addLineToPoint(CGPoint(x:x,y:rect.size.height))
        }

        func horizontalLine( y: CGFloat ) {
            bezier.moveToPoint(CGPoint(x:0,y:y))
            bezier.addLineToPoint(CGPoint(x:rect.size.width,y:y))
        }

        func verticalLines( xx : [CGFloat] ) {
            _ = xx.reduce( 0, combine: { (x, step) -> CGFloat in
                verticalLine( x + step )
                return x + step
            })
        }

        func horizontalLines( yy : [CGFloat] ) {
            _ = yy.reduce( 0, combine: { (y, step) -> CGFloat in
                horizontalLine( y + step )
                return y + step
            })
        }

        let verticals : [CGFloat] = [24,24,183*3,60,60,60,60]
        verticalLines( verticals.map{ $0 / 3.0 } )

        horizontalLines([371,
               24,34,36,8,36,
            12,24,34,36,8,36,
            36,
            1,
            36,34,24, 24,54,24, 24,54,24, 24,54,24,36,
            36,34,24, 24,34,24, 24,34,24, 24,34,24, 24,34,24, 36,
//            1,
            36,34,24, 24,34,24, 24,34,24, 24,34,24, 36,

            //123, 8,12,17,2.6,17,
            //18,17,18,4,18,18, 1, 18,17,12,12,27,12, 12,27,12, 12,27,12, 18, 18,17,12,12,17,12,12,17,12,18
            ].map{ $0 / 3.0})

        bezier.stroke()

        bezier.removeAllPoints()
        UIColor.yellowColor().setStroke()
        verticalLines([rect.size.width - 8])
        horizontalLines([18+44])
        bezier.stroke()
    }
    #endif
}

