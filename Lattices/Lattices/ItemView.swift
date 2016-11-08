//
//  ItemView.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/12.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class ItemView: UIView {

    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var progressView : UIProgressView?
    @IBOutlet weak var activityIndicatorView : UIActivityIndicatorView?

    func loadXib() {
        Bundle(for: type(of: self)).loadNibNamed("ItemView",
                                                          owner: self,
                                                          options: nil)
        button.titleLabel?.font = normalFont
        contentView.frame = self.bounds
        addSubview(self.contentView)
        translatesAutoresizingMaskIntoConstraints = false
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
            button.setTitle( text, for: UIControlState() )
        }
    }

    var fontSize : CGFloat = 16

    var normalFont : UIFont {
//        return UIFont.systemFont( ofSize: fontSize, weight: UIFontWeightThin)
        return UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFontWeightThin)
    }

    var selectedFont : UIFont {
//        return UIFont.systemFont( ofSize: fontSize, weight: UIFontWeightMedium)
        return UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: UIFontWeightMedium)
    }

    var selected: Bool = false {
        didSet {
            #if false
                let anim = CATransition()
                anim.type = kCATransitionFade
                anim.subtype = kCATransitionFade
                anim.duration = 0.15
                button.layer.addAnimation(anim, forKey: nil)
            #endif
            button.titleLabel?.font = selected ? selectedFont : normalFont
        }
    }

    var enabled: Bool = true {
        didSet {
            button.isEnabled = enabled
        }
    }

    override var tag: Int {
        didSet {
            button.tag = tag
        }
    }

    var action : Selector? = nil {
        didSet {
            button.addTarget(nil, action: action!, for: .touchUpInside )
        }
    }

    func startAnimating() {
        activityIndicatorView?.startAnimating()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
    }

    func stopAnimating() {
        activityIndicatorView?.stopAnimating()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
