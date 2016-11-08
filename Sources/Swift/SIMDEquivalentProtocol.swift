//
//  SimdConvertible.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import simd

public protocol SimdArithemtic {
    static func +(_:Self,_:Self)->Self
    static func -(_:Self,_:Self)->Self
    static func *(_:Self,_:Self)->Self
    static func /(_:Self,_:Self)->Self
}

public protocol SIMDEquivalent {
    associatedtype ArithmeticType
    static func Arithmetic( _:Self) -> ArithmeticType
    init(_:ArithmeticType)
}

func +<T:SIMDEquivalent>(l:T,r:T) -> T where T.ArithmeticType:SimdArithemtic {
    return T( T.Arithmetic(l) + T.Arithmetic(r) )
}

func -<T:SIMDEquivalent>(l:T,r:T) -> T where T.ArithmeticType:SimdArithemtic {
    return T( T.Arithmetic(l) - T.Arithmetic(r) )
}

func *<T:SIMDEquivalent>(l:T,r:T) -> T where T.ArithmeticType:SimdArithemtic {
    return T( T.Arithmetic(l) * T.Arithmetic(r) )
}

func /<T:SIMDEquivalent>(l:T,r:T) -> T where T.ArithmeticType:SimdArithemtic {
    return T( T.Arithmetic(l) / T.Arithmetic(r) )
}

extension double2 : SimdArithemtic {
}

extension double3 : SimdArithemtic {
}

extension double4 : SimdArithemtic {
}

extension float2 : SimdArithemtic {
}

extension float3 : SimdArithemtic {
}

extension float4 : SimdArithemtic {
}

