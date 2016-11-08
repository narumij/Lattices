//
//  BoolVector.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/23.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import simd

typealias Bool2 = (Bool,Bool)
typealias Bool3 = (Bool,Bool,Bool)
typealias Bool4 = (Bool,Bool,Bool,Bool)

func all( _ b: Bool2 ) -> Bool {
    return b.0 && b.1
}

func all( _ b: Bool3 ) -> Bool {
    return b.0 && b.1 && b.2
}

func all( _ b: Bool4 ) -> Bool {
    return b.0 && b.1 && b.2 && b.3
}

func any( _ b: Bool2 ) -> Bool {
    return b.0 || b.1
}

func any( _ b: Bool3 ) -> Bool {
    return b.0 || b.1 || b.2
}

func any( _ b: Bool4 ) -> Bool {
    return b.0 || b.1 || b.2 || b.3
}

prefix func !( b: Bool2 ) -> Bool2 {
    return ( !b.0, !b.1 )
}

prefix func !( b: Bool3 ) -> Bool3 {
    return ( !b.0, !b.1, !b.2 )
}

prefix func !( b: Bool4 ) -> Bool4 {
    return ( !b.0, !b.1, !b.2, !b.3 )
}

func not( _ b: Bool2 ) -> Bool2 {
    return ( !b.0, !b.1 )
}

func not( _ b: Bool3 ) -> Bool3 {
    return ( !b.0, !b.1, !b.2 )
}

func not( _ b: Bool4 ) -> Bool4 {
    return ( !b.0, !b.1, !b.2, !b.3 )
}

func && ( l: Bool2, r: Bool2 ) -> Bool2 {
    return ( l.0 && r.0, l.1 && r.1 )
}

func && ( l: Bool3, r: Bool3 ) -> Bool3 {
    return ( l.0 && r.0, l.1 && r.1, l.2 && r.2 )
}

func && ( l: Bool4, r: Bool4 ) -> Bool4 {
    return ( l.0 && r.0, l.1 && r.1, l.2 && r.2, l.3 && r.3 )
}

func || ( l: Bool2, r: Bool2 ) -> Bool2 {
    return ( l.0 || r.0, l.1 || r.1 )
}

func || ( l: Bool3, r: Bool3 ) -> Bool3 {
    return ( l.0 || r.0, l.1 || r.1, l.2 || r.2 )
}

func || ( l: Bool4, r: Bool4 ) -> Bool4 {
    return ( l.0 || r.0, l.1 || r.1, l.2 || r.2, l.3 || r.3 )
}

func == ( l: float2, r: float2 ) -> Bool2 {
    return ( l.x == r.x, l.y == r.y )
}

func == ( l: float3, r: float3 ) -> Bool3 {
    return ( l.x == r.x, l.y == r.y, l.z == r.z )
}

func == ( l: float4, r: float4 ) -> Bool4 {
    return ( l.x == r.x, l.y == r.y, l.z == r.z, l.w == r.w )
}

func != ( l: float2, r: float2 ) -> Bool2 {
    return ( l.x != r.x, l.y != r.y )
}

func != ( l: float3, r: float3 ) -> Bool3 {
    return ( l.x != r.x, l.y != r.y, l.z != r.z )
}

func != ( l: float4, r: float4 ) -> Bool4 {
    return ( l.x != r.x, l.y != r.y, l.z != r.z, l.w != r.w )
}

func < ( l: float2, r: float2 ) -> Bool2 {
    return ( l.x < r.x, l.y < r.y )
}

func < ( l: float3, r: float3 ) -> Bool3 {
    return ( l.x < r.x, l.y < r.y, l.z < r.z )
}

func < ( l: float4, r: float4 ) -> Bool4 {
    return ( l.x < r.x, l.y < r.y, l.z < r.z, l.w < r.w )
}

func <= ( l: float2, r: float2 ) -> Bool2 {
    return ( l.x <= r.x, l.y <= r.y )
}

func <= ( l: float3, r: float3 ) -> Bool3 {
    return ( l.x <= r.x, l.y <= r.y, l.z <= r.z )
}

func <= ( l: float4, r: float4 ) -> Bool4 {
    return ( l.x <= r.x, l.y <= r.y, l.z <= r.z, l.w <= r.w )
}

func > ( l: float2, r: float2 ) -> Bool2 {
    return ( l.x > r.x, l.y > r.y )
}

func > ( l: float3, r: float3 ) -> Bool3 {
    return ( l.x > r.x, l.y > r.y, l.z > r.z )
}

func > ( l: float4, r: float4 ) -> Bool4 {
    return ( l.x > r.x, l.y > r.y, l.z > r.z, l.w > r.w )
}

func >= ( l: float2, r: float2 ) -> Bool2 {
    return ( l.x >= r.x, l.y >= r.y )
}

func >= ( l: float3, r: float3 ) -> Bool3 {
    return ( l.x >= r.x, l.y >= r.y, l.z >= r.z )
}

func >= ( l: float4, r: float4 ) -> Bool4 {
    return ( l.x >= r.x, l.y >= r.y, l.z >= r.z, l.w >= r.w )
}







