//
//  WyckoffDetector.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import simd

enum WyckoffLetter : Int {
    case a,b,c,d,e,f,g
    case h,i,j,k,l,m,n
    case o,p,q,r,s,t,u
    case v,w,x,y,z,alpha
}

func fromLetter( _ letter: WyckoffLetter? ) -> String? {
    if let letter = letter {
        switch letter {
        case .a:
            return "a"
        case .b:
            return "b"
        case .c:
            return "c"
        case .d:
            return "d"
        case .e:
            return "e"
        case .f:
            return "f"
        case .g:
            return "g"
        case .h:
            return "h"
        case .i:
            return "i"
        case .j:
            return "j"
        case .k:
            return "k"
        case .l:
            return "l"
        case .m:
            return "m"
        case .n:
            return "n"
        case .o:
            return "o"
        case .p:
            return "p"
        case .q:
            return "q"
        case .r:
            return "r"
        case .s:
            return "s"
        case .t:
            return "t"
        case .u:
            return "u"
        case .v:
            return "v"
        case .w:
            return "w"
        case .x:
            return "x"
        case .y:
            return "y"
        case .z:
            return "z"
        case .alpha:
            return "α"
        }
    }
    return nil
}

enum WyckoffDetectorKind {
    case nothing,point,line,plane
}

func WyckoffPositionMake( matrix mat: Matrix4x4 ) -> WyckoffPosition {
    switch mat.rotatePart.columns.filter({ $0 != Vector3Zero }).count {
    case 0:
        return WyckoffPoint( matrix: mat )
    case 1:
        return WyckoffLine( matrix: mat )
    case 2:
        return WyckoffPlane( matrix: mat )
    default:
        break
    }
    return WyckoffPosition( matrix: mat )
}

class WyckoffPosition {
    var matrix: Matrix4x4
    func isEquiv( _ fract: Vector3 ) -> Bool {
        return false
    }
    func isEquiv( _ fract: Vector3, offset: Vector3 ) -> Bool {
        return false
    }
    func test( _ fract: Vector3 ) -> Bool {
        return false
    }
    init( matrix m: Matrix4x4 ) {
        matrix = m
    }
    var kind: WyckoffDetectorKind { return .nothing }
    func isTorelant( _ fract: Vector3 ) -> Bool {
        var offsets: [Vector3] = []
        for i in 0..<2 {
            for j in 0..<2 {
                for k in 0..<2 {
                    offsets.append( Vector3(FloatType(i),FloatType(j),FloatType(k)) )
                }
            }
        }
        for offset in offsets {
            if isEquiv( fract - offset ) {
                return true
            }
        }
        return false
    }
    static var epsilon: FloatType = 0.002
}


class WyckoffPoint : WyckoffPosition {
    let coordinate: Vector3
    override init( matrix mat: Matrix4x4 ) {
        coordinate = coordinateFromMatrix4x4(mat)
        super.init( matrix: mat )
    }
    override var kind: WyckoffDetectorKind { return .point }
    override func isEquiv(_ fract: Vector3) -> Bool {
        return distance( coordinate, fract ) < WyckoffPosition.epsilon
    }
}

class WyckoffLine : WyckoffPosition {
    let ray: Ray_t
    override init( matrix mat: Matrix4x4 ) {
        ray = lineFromMatrix4x4(mat)
        super.init( matrix: mat )
    }
    override var kind: WyckoffDetectorKind { return .line }
    override func isEquiv(_ fract: Vector3) -> Bool {
        return distance( fract, ray ) < WyckoffPosition.epsilon
    }
}

class WyckoffPlane: WyckoffPosition {
    let plane: Plane_t
    override init( matrix mat: Matrix4x4 ) {
        plane = planeFromMatrix4x4(mat)
        super.init( matrix: mat )
    }
    override var kind: WyckoffDetectorKind { return .plane }
    override func isEquiv(_ fract: Vector3) -> Bool {
        return distance( fract, plane ) < WyckoffPosition.epsilon
    }
}

private func coordinateFromMatrix4x4( _ m: Matrix4x4 ) -> Vector3 {
    return m.translatePart
}

private func lineFromMatrix4x4( _ m: Matrix4x4 ) -> Ray_t {
    let p = m.translatePart
    let mm = m.rotatePart
    let v = mm.columns.filter({ $0 !~~ Vector3Zero })
    return (p,normalize(v[0]))
}

private func planeFromMatrix4x4( _ m: Matrix4x4 ) -> Plane_t {
    let p = m.translatePart
    let mm = m.rotatePart
    let vv = mm.columns.filter({ $0 !~~ Vector3Zero })
    let v1 = vv[0]
    let v2 = vv[1]
    let pn = normalize(cross(normalize(v1),normalize(v2)))
    let pd = dot(pn,p)
    return (pn,pd)
}



