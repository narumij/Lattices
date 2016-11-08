//
//  GuideView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/02.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class GuideView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        #if true
            backgroundColor = UIColor.clear
        #endif
    }

//    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.item.hidden = true
//    }
}

