//
//  SymopEquiv.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/11.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func fromMatrix4x4(_ m: Matrix4x4) -> SymopEquivType {
    return ((m[0,0],m[0,1],m[0,2],m[0,3]),
            (m[1,0],m[1,1],m[1,2],m[1,3]),
            (m[2,0],m[2,1],m[2,2],m[2,3]))
}

func fromSymopEquivTuples(_ rows:SymopEquivType) -> Matrix4x4 {
    let rows = [Vector4(rows.0.0,rows.0.1,rows.0.2,rows.0.3),
                Vector4(rows.1.0,rows.1.1,rows.1.2,rows.1.3),
                Vector4(rows.2.0,rows.2.1,rows.2.2,rows.2.3),
                Vector4(0,0,0,1)]
    return Matrix4x4( rows: rows )
}

func fromIndex(_ itn:Int,_ stn:Int) -> [Matrix4x4] {
//  return symopTable(itn, stn).map{ fromRowsArray($0) }
    return symopTable3(itn, stn).map{ fromSymopEquivTuples($0) }
}

func xyzDescription(_ symop: SymopEquivType) -> String {

    func str(_ n:SymopType,_ label: String ) -> String {
        if n == 0 {
            return ""
        }
        if n == 1 {
            return label.isEmpty ? "+\(n)" : "+\(label)"
        }
        if n == -1 {
            return label.isEmpty ? "\(n)" : "-\(label)"
        }
        return "\(n)\(label)"
    }

    func hoge(_ row: (x:SymopType,y:SymopType,z:SymopType,w:SymopType) ) -> String {
        return [(row.x,"x"),(row.y,"y"),(row.z,"z"),(row.w,"")].map({str($0.0,$0.1)}).joined()
    }

    return [symop.0,symop.1,symop.2].map({hoge($0)}).joined(separator:",")
}





