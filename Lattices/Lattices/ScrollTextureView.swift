//
//  ScrollTextureView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/27.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class ScrollTextureView: UIView {

    var contentLayer : ScrollTextureLayer? {
        return self.layer as? ScrollTextureLayer
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        contentLayer?.backgroundColor = UIColor.redColor().CGColor
        contentLayer!.prepare( bounds )
        contentLayer?.masksToBounds = true
//        contentLayer?.backgroundColor = UIColor.whiteColor().CGColor
        contentLayer?.start()
    }

    class override var layerClass : AnyClass {
        return ScrollTextureLayer.self
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

