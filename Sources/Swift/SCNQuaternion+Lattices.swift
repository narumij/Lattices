//
//  SCNQuaternionExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/02.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

#if os(iOS)
    private typealias vec3_t = float3
    private typealias vec4_t = float4
    private typealias float_t = Float
#else
    private typealias vec3_t = double3
    private typealias vec4_t = double4
    private typealias float_t = Double
#endif

func == ( l: SCNQuaternion, r: SCNQuaternion ) -> Bool {
    return l.x == r.x && l.y == r.y && l.z == r.z && l.w == r.w
}

func =~~ ( l: SCNQuaternion, r: SCNQuaternion ) -> Bool {
    return l.x =~~ r.x && l.y =~~ r.y && l.z =~~ r.z && l.w =~~ r.w
}

func dot( _ left: SCNQuaternion,_ right: SCNQuaternion ) -> SCNFloat
{
    return SCNFloat( dot( vec4_t(left), vec4_t(right) ) )
}

public let SCNQuaternionIdentity = SCNQuaternion(0,0,0,1)

extension SCNQuaternion {
    fileprivate var _0:float_t { return float_t(x) }
    fileprivate var _1:float_t { return float_t(y) }
    fileprivate var _2:float_t { return float_t(z) }
    fileprivate var _3:float_t { return float_t(w) }
    fileprivate var q3012:vec4_t {
        return vec4_t(_3,_0,_1,_2)
    }
    fileprivate var q3120:vec4_t {
        return vec4_t(_3,_1,_2,_0)
    }
    fileprivate var q3201:vec4_t {
        return vec4_t(_3,_2,_0,_1)
    }
    fileprivate var q0321:vec4_t {
        return vec4_t(_0,_3,_2,_1)
    }
    fileprivate var q1302:vec4_t {
        return vec4_t(_1,_3,_0,_2)
    }
    fileprivate var q2310:vec4_t {
        return vec4_t(_2,_3,_1,_0)
    }
}

func * ( l: SCNQuaternion, r: SCNQuaternion ) -> SCNQuaternion
{
    let x = vector_reduce_add( l.q3012 * r.q0321 * vec4_t( 1, 1, 1,-1 ) )
    let y = vector_reduce_add( l.q3120 * r.q1302 * vec4_t( 1, 1, 1,-1 ) )
    let z = vector_reduce_add( l.q3201 * r.q2310 * vec4_t( 1, 1, 1,-1 ) )
    let w = vector_reduce_add( l.q3012 * r.q3012 * vec4_t( 1,-1,-1,-1 ) )
    return SCNQuaternion( x, y, z, w )
}

func * ( quaternion: SCNQuaternion, vector: SCNVector3 ) -> SCNVector3 {
    var rotatedQuaternion = SCNQuaternion( vector.x, vector.y, vector.z, 0 )
    rotatedQuaternion = quaternion * rotatedQuaternion * invert(quaternion);
    return SCNVector3( rotatedQuaternion.x, rotatedQuaternion.y, rotatedQuaternion.z );
}


func invert( _ quaternion: SCNQuaternion ) -> SCNQuaternion {
    let quat = vec4_t(quaternion)
    let scale = 1 / dot(quat,quat)
    return SCNQuaternion( scale * quat * vec4_t( -1, -1, -1, 1 )  )
}

func length( _ quaternion: SCNQuaternion ) -> SCNFloat
{
    let quat = vec4_t(quaternion)
    return SCNFloat( length( quat ) )
}

func normalize( _ quaternion: SCNQuaternion ) -> SCNQuaternion {
    let quat = vec4_t(quaternion)
    let scale = 1 / length(quat);
    return SCNQuaternion( quat * scale )
}

func slerp( _ quaternionStart: SCNQuaternion, _ quaternionEnd: SCNQuaternion, _ t: SCNFloat ) -> SCNQuaternion {
    let start = GLKQuaternion(quaternionStart)
    let end = GLKQuaternion(quaternionEnd)
    let q = GLKQuaternionSlerp(start, end, t)
    return SCNQuaternion(q)
}

extension GLKQuaternion {
    init( _ scn: SCNQuaternion ) {
        q.0 = scn.x
        q.1 = scn.y
        q.2 = scn.z
        q.3 = scn.w
    }
}

extension SCNQuaternion {

    init( _ glk: GLKQuaternion ) {
        x = glk.q.0
        y = glk.q.1
        z = glk.q.2
        w = glk.q.3
    }

    init( angles: SCNFloat, axis: SCNVector3 )
    {
        self.init( angles: angles, x: axis.x, y: axis.y, z: axis.z )
    }

    init( angles: SCNFloat, x: SCNFloat, y: SCNFloat, z: SCNFloat )
    {
        let halfAngle = angles * 0.5;
        let scale = sin(halfAngle);
        self.x = scale * x
        self.y = scale * y
        self.z = scale * z
        self.w = cos(halfAngle)
    }

    init(_ m: SCNMatrix4 ) {
        var s: SCNFloat = 0
        var i: Int = 0
        var j: Int = 0
        var k: Int = 0
        let nxt: [Int] = [ 1, 2, 0 ];
        var _array: [SCNFloat] = [0,0,0,0]
        let tr = m[0,0] + m[1,1] + m[2,2]
        if ( tr > 0 )
        {
            s = sqrt( tr + m[3,3] )
            _array[3] = s * 0.5
            s = 0.5 / s
            _array[0] = ( m[1,2] - m[2,1] ) * s
            _array[1] = ( m[2,0] - m[0,2] ) * s
            _array[2] = ( m[0,1] - m[1,0] ) * s
        }
        else
        {
            i = 0;
            if m[1,1] > m[0,0] {
                i = 1;
            }
            if m[2,2] > m[i,i] {
                i = 2;
            }
            j = nxt[i];
            k = nxt[j];
            s = sqrt( ( m[i,j] - ( m[j,j] + m[k,k] ) ) + 1.0 );
            _array[i] = s * 0.5;
            s = 0.5 / s;
            _array[3] = ( m[j,k] - m[k,j] ) * s;
            _array[j] = ( m[i,j] + m[j,i] ) * s;
            _array[k] = ( m[i,k] + m[k,i] ) * s;
        }
        self.x = _array[0]
        self.y = _array[1]
        self.z = _array[2]
        self.w = _array[3]
    }

    init( angles: Double, axis: double3 )
    {
        self.init( angles: SCNFloat(angles), axis: SCNVector3(axis) )
    }

    init( angles: Float, axis: float3 )
    {
        self.init( angles: SCNFloat(angles), axis: SCNVector3(axis) )
    }

    init( from: SCNVector3, to: SCNVector3 )
    {


        let rotateFrom = vec3_t(from)
        let rotateTo = vec3_t(to)

        var p1 = normalize(rotateFrom);
        let p2 = normalize(rotateTo);

        let alpha = dot( p1, p2);

        if( alpha == 1.0 ) {
            self.init(0,0,0,1)
            return
        }

        // ensures that the anti-parallel case leads to a positive dot
        if( alpha == -1.0)
        {
            var v: vec3_t;

            if(p1[0] != p1[1] || p1[0] != p1[2])
            {
                v = vec3_t(p1[1], p1[2], p1[0]);
            }
            else
            {
                v = vec3_t(-p1[0], p1[1], p1[2]);
            }

            v -= p1 * dot( p1, v);
            v = normalize(v);

            self.init( angles: float_t.pi, axis: v )
            return
        }

        p1 = normalize( cross( p1, p2));
        self.init( angles: acos(alpha), axis:p1 )
    }

    typealias LookUp = (look:SCNVector3,up:SCNVector3)

    init( from: LookUp, to: LookUp ) {
        let r_look : SCNQuaternion = SCNQuaternion( from: from.look, to: to.look )
        let r_twist : SCNQuaternion = SCNQuaternion( from: r_look * from.up, to: to.up )
        self.init( r_twist * r_look )
    }

    init(_ q: SCNQuaternion )
    {
        self.x = q.x
        self.y = q.y
        self.z = q.z
        self.w = q.w
    }

    #if false
    static func ModelLookUp( fromLook: SCNVector3, fromUp: SCNVector3, toLook: SCNVector3, toUp: SCNVector3 ) -> SCNQuaternion {
        let r_look = SCNQuaternion( from: fromLook, to: toLook )
        let rotated_from_up = r_look * fromUp
        let r_twist = SCNQuaternion( from: rotated_from_up, to: toUp )
        return r_twist * r_look
    }

    static func CameraLookUp( fromLook: SCNVector3, fromUp: SCNVector3, toLook: SCNVector3, toUp: SCNVector3 ) -> SCNQuaternion {
        let r_look = SCNQuaternion( from: fromLook, to: toLook )
        let rotated_from_up = r_look * fromUp
        let r_twist = SCNQuaternion( from: rotated_from_up, to: toUp )
        return r_look * r_twist
    }
    #endif
}

extension SCNMatrix4 {

    init(_ m11: SCNFloat,_ m12: SCNFloat,_ m13: SCNFloat,_ m14: SCNFloat,
         _ m21: SCNFloat,_ m22: SCNFloat,_ m23: SCNFloat,_ m24: SCNFloat,
         _ m31: SCNFloat,_ m32: SCNFloat,_ m33: SCNFloat,_ m34: SCNFloat,
         _ m41: SCNFloat,_ m42: SCNFloat,_ m43: SCNFloat,_ m44: SCNFloat )
    {
        self.init( m11: m11, m12: m12, m13: m13, m14: m14,
                   m21: m21, m22: m22, m23: m23, m24: m24,
                   m31: m31, m32: m32, m33: m33, m34: m34,
                   m41: m41, m42: m42, m43: m43, m44: m44 )
    }

    init( quat: SCNQuaternion )
    {
        let quaternion = normalize(quat);

        let x = quaternion.x;
        let y = quaternion.y;
        let z = quaternion.z;
        let w = quaternion.w;

        let _2x = x + x;
        let _2y = y + y;
        let _2z = z + z;
        let _2w = w + w;

        self.init( 1.0 - _2y * y - _2z * z,
                   _2x * y + _2w * z,
                   _2x * z - _2w * y,
                   0.0,
                   _2x * y - _2w * z,
                   1.0 - _2x * x - _2z * z,
                   _2y * z + _2w * x,
                   0.0,
                   _2x * z + _2w * y,
                   _2y * z - _2w * x,
                   1.0 - _2x * x - _2y * y,
                   0.0,
                   0.0,
                   0.0,
                   0.0,
                   1.0 );
    }

}


