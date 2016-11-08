//
//  SymmetryOperationsQuery.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/05/30.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

func removeLastWhites(_ str:String) -> String {
    let nsstr = str as NSString
    let range = NSRange(location: 0, length: nsstr.length)
    return (nsstr.replacingOccurrences(of: "[:blank:]+$", with: "", options: NSString.CompareOptions.regularExpression, range: range))
}

func removeLastSingleQuote(_ str:String) -> String {
    let nsstr = str as NSString
    let range = NSRange(location: 0, length: nsstr.length)
    return (nsstr.replacingOccurrences(of: "\'$", with: "", options: NSString.CompareOptions.regularExpression, range: range))
}

func removeAllWhites(_ str:String) -> String {
    let nsstr = str as NSString
    let range = NSRange(location: 0, length: nsstr.length)
    return (nsstr.replacingOccurrences(of: "[:blank:]", with: "", options: NSString.CompareOptions.regularExpression, range: range))
}

func spacegroupIndex( hall:String?, hm:String? ) -> (Int,Int)? {
//    debugPrint(hall)
//    debugPrint(hm)
    let hallIndex = hall != nil ? spacegroupHallToSymopIndex(hall!) : nil
    let hmIndex = hm != nil ? spacegroupHMToSymopIndex(hm!) : nil
    let hmIndex2 = hall != nil ? spacegroupHMToSymopIndex(hall!) : nil
    let indices = [hallIndex,hmIndex,hmIndex2].filter{$0 != nil}.map{ $0! }
    return indices.count > 0 ? indices[0] : nil
}

func hoge<T>( _ f: (T)->T, _ arg: T? ) -> T? {
    return arg != nil ? f(arg!) : nil
}

func spacegroupIndex3(hall:String?, hm:String?) -> (Int,Int)? {
    let hall0 = hoge(removeLastWhites,hall)
    let hall1 = hoge(removeLastSingleQuote,hall0)
    let hm0 = hoge(removeLastWhites,hm)
    let hm1 = hoge(removeLastSingleQuote,hm0)
    if let index = spacegroupIndex( hall: hall1, hm: hm1 ) {
        return index
    }
    return spacegroupIndex(hall: hoge(removeAllWhites,hall1), hm: hoge(removeAllWhites,hm1))
}

/*
func matricesFromSpacegroupName(hall hall:String?, hm:String?) -> [Matrix4x4] {
    func fromRows(rows:[[SymopType]]) -> Matrix4x4 {
        let _rows = rows + [[0,0,0,1]]
        return Matrix4x4(rows:_rows.map{ Vector4( $0 ) } )
    }
//    func fromRowsArray(array:[[[SymopType]]]) -> [Matrix4x4] {
//        return array.map{ fromRows($0) }
//    }
    func fromIndex(itn:Int,_ stn:Int) -> [Matrix4x4] {
//        return symopTable(itn, stn).map{ fromRowsArray($0) }
        return symopTable(itn, stn).map{ fromRows($0) }
    }
    let idx = spacegroupIndex2( hall: hall, hm: hm)
    return idx != nil ? fromIndex(idx!.0,idx!.1) : []
}
*/



func matricesFromSpacegroupName3(hall:String?, hm:String?) -> [Matrix4x4] {
    //    func fromRowsArray(array:[[[SymopType]]]) -> [Matrix4x4] {
    //        return array.map{ fromRows($0) }
    //    }
    let idx = spacegroupIndex3( hall: hall, hm: hm)
    return idx != nil ? fromIndex(idx!.0,idx!.1) : []
}




