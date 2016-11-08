//
//  CoreGraphics+Lattices.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import CoreGraphics
import simd

extension double2 {
    public init( _ x: CGFloat, _ y: CGFloat ) {
        self.init( Double(x), Double(y) )
    }
    public init( _ size: CGSize ) {
        self.init( size.width, size.height )
    }
    public init( _ point: CGPoint ) {
        self.init( point.x, point.y )
    }
}

extension CGSize : SIMDEquivalent {
    public typealias ArithmeticType = double2
    public static func Arithmetic( _ s: CGSize ) -> ArithmeticType {
        return double2( s )
    }
    public init( _ d: double2 ) {
        self.init( width: d.x, height: d.y )
    }
}

extension CGPoint : SIMDEquivalent {
    public typealias ArithmeticType = double2
    public static func Arithmetic( _ p: CGPoint ) -> ArithmeticType {
        return double2( p )
    }
    public init( _ d: double2 ) {
        self.init( x: d.x, y: d.y )
    }
}

func distance( _ l: CGPoint, r: CGPoint ) -> CGFloat {
    return CGFloat(distance(CGPoint.Arithmetic(l),CGPoint.Arithmetic(r)))
}

extension CGRect {
    public var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}




