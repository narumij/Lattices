//
//  Radii.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/22.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

struct CrystalRadius {
    let symbol : String
    let radius : RadiiSizeType
    let colorVector : SCNVector3
    var color : Color {
        return Color( rgb: Vector3(colorVector), alpha: 1.0 )
    }
}

//func cleanElem(str:String) -> String {
//    let pattern = "^[a-zA-Z]+"
//    let ret:[String] = Regexp(pattern).matches(str)
//    if  ret.count == 0 {
//        return ""
//    }
//    return ret[0]
//}

func getRadius( _ radii: [CrystalRadius], atomicSymbol: AtomicSymbol ) -> RadiiSizeType
{
//    debugPrint("getRadius( \(symbol), \(label) )")
//    let sym = cleanElem(symbol)
//    let lab = cleanElem(label)
//    if sym.length != 0 {
    return radii.filter({$0.symbol == atomicSymbol.rawValue}).first?.radius ?? 1.0
//    }
//    else if lab.length != 0 {
//        return radii.filter({$0.symbol == lab}).first?.radius ?? 1.0
//    }
//    return 1.0
}

func getColorVector( _ radii: [CrystalRadius], atomicSymbol: AtomicSymbol ) -> SCNVector3
{
//    debugPrint("getColorVector( \(symbol), \(label) )")
//    let pattern = "^[a-zA-Z]+"
//    let ret:[String] = Regexp(pattern).matches(symbol)
//    let pureSymbol = ret[0]
//    return pureSymbol != "" ? radii.filter({$0.symbol == pureSymbol}).first!.colorVector : SCNVector3(1,1,1)
//    let sym = cleanElem(symbol)
//    let lab = cleanElem(label)
//    if sym.length != 0 {
        return radii.filter({$0.symbol == atomicSymbol.rawValue}).first?.colorVector ?? SCNVector3(1,1,1)
//    }
//    else if lab.length != 0 {
//        return radii.filter({$0.symbol == lab}).first?.colorVector ?? SCNVector3(1,1,1)
//    }
//    return SCNVector3(1,1,1)
}

func getColor( _ radii: [CrystalRadius], atomicSymbol: AtomicSymbol ) -> Color
{
//    debugPrint("getColor( \(symbol), \(label) )")
//    let sym = cleanElem(symbol)
//    let lab = cleanElem(label)
//    if sym.length != 0 {
        return radii.filter({$0.symbol == atomicSymbol.rawValue}).first?.color ?? Color.white
//    }
//    else if lab.length != 0 {
//        return radii.filter({$0.symbol == lab}).first?.color ?? Color.whiteColor()
//    }
//    return Color.whiteColor()
}

/*
func readRadii( _ string: String ) -> [CrystalRadius] {
    var blocks = string.components(separatedBy: "\nELMT")
    var lines = blocks[1].components(separatedBy: "\n")
    var radii : [CrystalRadius] = []
    for line in lines {
        if line.length == 0 {
            continue
        }
        var words : [NSString] = line
            .components(separatedBy: CharacterSet(charactersIn: " \t"))
            .filter({ (s) -> Bool in
                s.length > 0
            })
        func vec( _ x:NSString, _ y:NSString, _ z: NSString ) -> SCNVector3 {
            return SCNVector3( x.doubleValue, y.doubleValue, z.doubleValue )
        }
        radii.append(CrystalRadius(symbol: words[0] as String,
            radius: RadiiSizeType(words[1].doubleValue),
            colorVector: vec(words[2],words[3],words[4])))
    }
    return radii
}
*/


