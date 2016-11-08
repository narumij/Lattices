//
//  TypeView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class TypeView: UIView {

    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var colorView: TypeColorView!
    @IBOutlet weak var label: UILabel!

    func loadXib() {
        Bundle(for: type(of: self)).loadNibNamed("TypeView",
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

    var color: UIColor = UIColor.purple {
        didSet {
            colorView.color = color
        }
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
