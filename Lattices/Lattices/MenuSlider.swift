//
//  MenuSlider.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class MenuSlider: UISlider {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        setThumbImage(UIImage(named: "SliderNob"), for: UIControlState())
        setThumbImage(UIImage(named: "SliderNob"), for: .highlighted)
        setThumbImage(UIImage(named: "SliderNob"), for: .selected)
        setThumbImage(UIImage(named: "SliderNob"), for: .disabled)
    }

//    override func trackRectForBounds( bounds: CGRect) -> CGRect {
//        let height : CGFloat = 8.0 / 3.0
//        let width = bounds.size.width
//        let x = bounds.origin.x
//        let y = ( bounds.size.height / 2.0 ) - height / 2.0
//        return CGRect(x: x, y: y, width: width, height: height)
//    }
}
