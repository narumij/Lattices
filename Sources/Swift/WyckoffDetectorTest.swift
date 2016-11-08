//
//  WyckoffDetectorTest.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func wyckoffPositions() -> [Vector3] {
    func myRandom() -> FloatType {
        let f = FloatType( Double(arc4random()) / Double(RAND_MAX) )
        assert(0<=f&&f<=1)
//        debugPrint("\(f)")
        return f
    }
    var array: [Vector3] = []
    let wd = WyckoffPositionMake( matrix: XYZParse("x+1/2,x,z") )
    for _ in 0..<100000 {
        let v = Vector3(myRandom(),myRandom(),myRandom())
        if wd.isTorelant(v) {
            array.append(v)
        }
    }
    debugPrint("vertices count: \(array.count)")
    return array
}

