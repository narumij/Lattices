//
//  DummyModelObject.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/17.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class DummyModelObject: NSObject, ModelObject {
    fileprivate(set) var URL: Foundation.URL
    fileprivate(set) var displayName = ""
    fileprivate(set) var subtitle = ""
    override init() {
        URL = NSURL() as URL
    }
}

