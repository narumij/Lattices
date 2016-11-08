//
//  TimerTarget.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

#if false
class TimerTarget {
    weak var target: AnyObject?
    var selector: Selector
    init(_ target: AnyObject?, selector: Selector ) {
        self.target = target
        self.selector = selector
    }
    convenience init(_ target: AnyObject? ) {
        self.init( target, selector: #selector(fire) )
    }
    @objc func fire() {
        target?.performSelector(selector)
    }
}
#endif

class TimerAdapter {
    let proc : ()->Void
    init( _ p: @escaping ()->Void ){
        proc = p
    }
    @objc func fire() {
        proc()
    }
}
