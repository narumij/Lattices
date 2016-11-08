//
//  LatticeCoord.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

public typealias LatticeCoord = int3

extension LatticeCoord : Hashable {
    public var hashValue : Int {
        return Int( (5 + x) + (5 + y) * 11 + (5 + z) * 101  )
    }
}

func latticeCoordFullOffsets() -> [LatticeCoord] {
    var offsets : [LatticeCoord] = []
    for i in [-1,0,1] {
        for j in [-1,0,1] {
            for k in [-1,0,1] {
                offsets.append(LatticeCoord(i,j,k))
            }
        }
    }
    return offsets
}

extension LatticeCoord : Equatable {
}

public func == ( left: LatticeCoord, right: LatticeCoord ) -> Bool {
    return left.x == right.x && left.y == right.y && left.z == right.z
}

func != ( left: LatticeCoord, right: LatticeCoord ) -> Bool {
    return !(left == right)
}

func + ( left: LatticeCoord, right: LatticeCoord ) -> LatticeCoord {
    return LatticeCoord( left.x + right.x, left.y + right.y, left.z + right.z )
}

func - ( left: LatticeCoord, right: LatticeCoord ) -> LatticeCoord {
    return LatticeCoord( left.x - right.x, left.y - right.y, left.z - right.z )
}

extension Vector3 {
    init( _ latticeCoord: LatticeCoord ) {
        self.init()
        x = FloatType( latticeCoord.x )
        y = FloatType( latticeCoord.y )
        z = FloatType( latticeCoord.z )
    }
}

extension LatticeCoord {
    init( _ x: Int, _ y: Int, _ z: Int ) {
        self.init()
        self.x = Int32(x)
        self.y = Int32(y)
        self.z = Int32(z)
    }
}

let LatticeCoordZero = LatticeCoord(0,0,0)

