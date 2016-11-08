//
//  SCNMatrix.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

func * ( l: SCNMatrix4, r: SCNMatrix4 ) -> SCNMatrix4 {
    return SCNMatrix4Mult(l, r)
}

extension SCNMatrix4 {
    init(row1:SCNVector4,row2:SCNVector4,row3:SCNVector4,row4:SCNVector4) {
        self.init()
        self.row1 = row1
        self.row2 = row2
        self.row3 = row3
        self.row4 = row4
    }
    init(col1:SCNVector4,col2:SCNVector4,col3:SCNVector4,col4:SCNVector4) {
        self.init()
        self.col1 = col1
        self.col2 = col2
        self.col3 = col3
        self.col4 = col4
    }
    init(rows:[SCNVector4]) {
        self.init()
        self.row1 = rows[0]
        self.row2 = rows[1]
        self.row3 = rows[2]
        self.row4 = rows[3]
    }
    init(cols:[SCNVector4]) {
        self.init()
        self.col1 = cols[0]
        self.col2 = cols[1]
        self.col3 = cols[2]
        self.col4 = cols[3]
    }
    var row1 : SCNVector4 {
        get { return SCNVector4Make( m11, m12, m13, m14 ) }
        set ( row ) { m11 = row.x; m12 = row.y; m13 = row.z; m14 = row.w }
    }
    var row2 : SCNVector4 {
        get { return SCNVector4Make( m21, m22, m23, m24 ) }
        set ( row ) { m21 = row.x; m22 = row.y; m23 = row.z; m24 = row.w }
    }
    var row3 : SCNVector4 {
        get { return SCNVector4Make( m31, m32, m33, m34 ) }
        set ( row ) { m31 = row.x; m32 = row.y; m33 = row.z; m34 = row.w }
    }
    var row4 : SCNVector4 {
        get { return SCNVector4Make( m41, m42, m43, m44 ) }
        set ( row ) { m41 = row.x; m42 = row.y; m43 = row.z; m44 = row.w }
    }

    var col1 : SCNVector4 {
        get { return SCNVector4Make( m11, m21, m31, m41 ) }
        set ( col ) { m11 = col.x; m21 = col.y; m31 = col.z; m41 = col.w }
    }
    var col2 : SCNVector4 {
        get { return SCNVector4Make( m12, m22, m32, m42 ) }
        set ( col ) { m12 = col.x; m22 = col.y; m32 = col.z; m42 = col.w }
    }
    var col3 : SCNVector4 {
        get { return SCNVector4Make( m13, m23, m33, m43 ) }
        set ( col ) { m13 = col.x; m23 = col.y; m33 = col.z; m43 = col.w }
    }
    var col4 : SCNVector4 {
        get { return SCNVector4Make( m14, m24, m34, m44 ) }
        set ( col ) { m14 = col.x; m24 = col.y; m34 = col.z; m44 = col.w }
    }

    var show : String {
        return row1.show + "\n" + row2.show + "\n" + row3.show + "\n" + row4.show + "\n"
    }
    subscript(row: Int, col: Int) -> SCNFloat {
        get {
            switch (row,col) {
            case (0,0):
                return m11
            case (1,0):
                return m21
            case (2,0):
                return m31
            case (3,0):
                return m41
            case (0,1):
                return m12
            case (1,1):
                return m22
            case (2,1):
                return m32
            case (3,1):
                return m42
            case (0,2):
                return m13
            case (1,2):
                return m23
            case (2,2):
                return m33
            case (3,2):
                return m43
            case (0,3):
                return m14
            case (1,3):
                return m24
            case (2,3):
                return m34
            case (3,3):
                return m44
            default:
                return 0.0
            }
        }
        set (value) {
            switch (row,col) {
            case (0,0):
                m11 = value
            case (1,0):
                m21 = value
            case (2,0):
                m31 = value
            case (3,0):
                m41 = value
            case (0,1):
                m12 = value
            case (1,1):
                m22 = value
            case (2,1):
                m32 = value
            case (3,1):
                m42 = value
            case (0,2):
                m13 = value
            case (1,2):
                m23 = value
            case (2,2):
                m33 = value
            case (3,2):
                m43 = value
            case (0,3):
                m14 = value
            case (1,3):
                m24 = value
            case (2,3):
                m34 = value
            case (3,3):
                m44 = value
            default:
                debugPrint("out of range")
            }
        }
    }
    var trans : SCNMatrix4 {
        return SCNMatrix4.init(cols: [row1,row2,row3,row4])
    }
}
