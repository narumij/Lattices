//
//  NSLockExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension NSLock {
    func syncBlock( _ block: (()->Void) ) {
        self.lock()
        block()
        self.unlock()
    }

    func tryBlock( _ block: (()->Void) ) {
        if self.try() {
            block()
            self.unlock()
        }
    }
}

