//
//  XYZ+Matrix.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func XYZParse(_ str:String) -> Matrix4x4 {
    let rows = XYZParse__(str) + [[0,0,0,1]]
    return Matrix4x4(rows: rows.map({ Vector4($0)}) )
}


