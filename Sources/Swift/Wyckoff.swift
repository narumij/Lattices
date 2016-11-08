//
//  Wyckoff.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/10.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

struct SpacegroupIndex_t {
    var itNumber : Int
    var subNumber : Int
    init( _ i: Int, _ s: Int ) {
        itNumber = i
        subNumber = s
    }
    var equiv: [SymopEquivType] {
        return symopTable3(itNumber, subNumber)
    }
    var matrices: [Matrix4x4] {
        return []
    }
}

func == (l:SpacegroupIndex_t,r:SpacegroupIndex_t)->Bool{
    return l.itNumber == r.itNumber && l.subNumber == r.subNumber
}

extension SpacegroupIndex_t : Hashable {
    var hashValue : Int {
        return itNumber + subNumber * 3
    }
}

let xyz = "x,y,z"

//typealias SG = SpacegroupIndex_t

typealias WyckoffDataItem = (multiplicity:Int,letter:WyckoffLetter,siteSymmetry:String,xyz:String)


func wyckoffIndices() -> [(Int,Int)] {
    return wyckoffData.keys.map{ ( $0.itNumber, $0.subNumber ) }
}

func applyWyckoff( matrix m: Matrix4x4, wyckoff w: Matrix4x4 ) -> Matrix4x4 {
    let mm = m * w
    var mat = Matrix4x4Identity
    mat.rotatePart = mm.rotatePart
    mat.translatePart = fract(mm.translatePart)
    return mat
}

func generateWyckoffData( _ itn: Int, _ stn: Int ) -> [WyckoffItem] {
    if let data = wyckoffData[SpacegroupIndex_t(itn,stn)] {
        return generateWyckoffData( data, symop: fromIndex( itn, stn ) )
    }
    return []
}

func generateWyckoffData( _ data: [WyckoffDataItem], symop:[Matrix4x4] ) -> [WyckoffItem] {
    return data.map{
        (item) in
        let wyckoffMatrices = nub( symop.map({
            applyWyckoff( matrix: $0, wyckoff: XYZParse(item.xyz) )
        }), isEquivalent: { $0 =~~ $1 } )
        let wyckoffPositions = wyckoffMatrices.map({
            WyckoffPositionMake(matrix: $0)
        })
        return WyckoffItem(
            multiplicity: item.multiplicity,
            letter: item.letter,
            siteSymmetry: item.siteSymmetry,
            positions: wyckoffPositions )
    }
}

class WyckoffItem {
    let letter: WyckoffLetter
    let multiplicity: Int
    let siteSymmetry: String
    let positions: [WyckoffPosition]
    init( multiplicity m: Int,
          letter l: WyckoffLetter,
          siteSymmetry s: String,
          positions p: [WyckoffPosition] ) {
        letter = l
        multiplicity = m
        siteSymmetry = s
        positions = p
        assert(multiplicity == positions.count)
    }
    func isTorelant( _ fract: Vector3 ) -> Bool {
        for position in positions {
            if position.isEquiv( fract ) {
                return true
            }
        }
        return false
    }
}











