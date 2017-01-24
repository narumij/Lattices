//
//  Geometry.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/23.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import simd

typealias Plane_t = (n:Vector3,d:FloatType)
typealias Ray_t = (p:Vector3,d:Vector3)
typealias Segment_t = (p1:Vector3,p2:Vector3)

func IntersectRayPlane( r: Ray_t, p: Plane_t, t: inout FloatType, q: inout Vector3 ) -> Bool {
    let ab = r.d
    let a = r.p
    t = (p.d - dot(p.n,a)) / dot(p.n,ab)
    if t >= 0.0 && t <= 1.0 {
        q = a + t * ab
        return true
    }
    return false
}

func distance( _ q: Vector3, _ p: Plane_t ) -> FloatType {
    return abs( ( dot( p.n, q ) - p.d ) / dot( p.n, p.n ) )
}

func distance( _ c: Vector3, _ ray: Ray_t ) -> FloatType {
    return distance( c, closestPtRay(point: c, ray: ray) )
}

func closestPtRay( point c: Vector3, ray: Ray_t ) -> Vector3 {
    let a = ray.p
//    let b = ray.p+ray.d
    let ab = ray.d
    let t = dot( c - a, ab ) / dot( ab, ab )
    return a + t * ab
}

func closestPtLine( point c: Vector3, line: (a: Vector3, b: Vector3) ) -> Vector3 {
    let a = line.a
    let b = line.b
    let ab = b - a
    let t = dot( c - a, ab ) / dot( ab, ab )
    return a + t * ab
}

func closestPtLine( point c: Vector3, line: (a: Vector3, b: Vector3) , t: inout FloatType, d: inout Vector3 ) {
    let a = line.a
    let b = line.b
    let ab = b - a
    t = dot( c - a, ab ) / dot( ab, ab )
    d = a + t * ab
}

func closestPtLine( c: double3, a: double3, b: double3 ) -> double3 {
    let ab = b - a
    let t = dot( c - a, ab ) / dot( ab, ab )
    return a + t * ab
}

func closestPtLine( c: double3, a: double3, b: double3, t: inout Double, d: inout double3 ) {
    let ab = b - a
    t = dot( c - a, ab ) / dot( ab, ab )
    d = a + t * ab
}

struct AABB_t {
    let origin : Vector3
    let size : Vector3

    init() {
        origin = Vector3Zero
        size = Vector3Zero
    }

    init( origin o: Vector3, size s: Vector3 ) {
        origin = o
        size = s
    }

    func contains( _ pos: Vector3 ) -> Bool {
        let mins = min(origin,origin+size)
        let maxs = max(origin,origin+size)
        //        return all( mins |<=| pos ) && all( pos |<=| maxs )
        //        return all( mins <= pos ) && all( pos <= maxs )
        return all( (mins <= pos) && (pos <= maxs) )
    }
}



