//
//  TitleView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/12.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class TitleView: UIView {

    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var leadingConstraint : NSLayoutConstraint!

    var leadingSpace : CGFloat = 8 {
        didSet {
            leadingConstraint.constant = leadingSpace
        }
    }

    func loadXib() {
        Bundle(for: type(of: self)).loadNibNamed("TitleView",
                                                          owner: self,
                                                          options: nil)
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    var text: String = "" {
        didSet {
            label.text = text
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
