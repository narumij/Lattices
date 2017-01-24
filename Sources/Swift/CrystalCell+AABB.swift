//
//  CrystalCell+AABB.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import simd

extension CrystalCell_t {

    func primitiveAABB( _ center: Vector3, radius: FloatType ) -> AABB_t {
        let o = Vector3Zero
        func IntersectPos( _ d: Vector3, p: Plane_t ) -> FloatType {
            return ( p.d - dot( p.n, o ) ) / dot( p.n, d )
        }
        let na = normalize(aVector)
        let nb = normalize(bVector)
        let nc = normalize(cVector)
        let ab = cross(na,nb)
        let bc = cross(nb,nc)
        let ac = cross(na,nc)

        let x = abs( IntersectPos( aVector, p: ( bc, radius ) ) )
        let y = abs( IntersectPos( bVector, p: ( ac, radius ) ) )
        let z = abs( IntersectPos( cVector, p: ( ab, radius ) ) )

        let halfSize = vector3(x,y,z)

        return AABB_t( origin: center - halfSize, size: halfSize * 2 )
    }

    func clampledAABB( _ center: Vector3, radius: FloatType ) -> AABB_t {
        let aabb = primitiveAABB( center, radius: radius )
        return AABB_t( origin: aabb.origin, size: min( aabb.size, vector3(1) ) )
    }

    func fractionalAABB( fractionalCenter center: Vector3, cartesianRadius radius: FloatType ) -> AABB_t? {
        // TODO: 1.1.1 require here
        assert(radius >= 0)
        if radius <= 0.0 {
            return nil
        }
        let aabb = clampledAABB( center, radius: radius )
        return all( aabb.size >= vector3(1.0) ) ? nil : aabb
    }


}

extension AABB_t {
    func fractionalContains( _ pos: Vector3 ) -> Bool {
        let b = size >= vector3(1.0)
        let mins = min(origin,origin+size)
        let maxs = max(origin,origin+size)
        //        return all( mins |<=| pos ) && all( pos |<=| maxs )
        //        return all( mins <= pos ) && all( pos <= maxs )
        return all( b || (mins <= pos) && (pos <= maxs) )
    }
}






