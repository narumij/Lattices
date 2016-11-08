//
//  SiteSymmetry.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/22.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

// http://www.iucr.org/__data/iucr/cifdic_html/1/cif_core.dic/Igeom_bond_site_symmetry_.html

import Foundation

enum SymmetryCodeType: Int {
    case nothing
    case dot
    case q
    case n
    case n_klm
}

struct SymmetryCode_t {

    let n : Int?
    let xyz : LatticeCoord?
    var type : SymmetryCodeType

    init()
    {
        type = .nothing
        n = nil
        xyz = nil
    }

    init( _ __n: Int ) {
        n = __n
        xyz = LatticeCoordZero
        type = .n
    }

    init( _ __n: Int, _ __klm: LatticeCoord ) {
        n = __n
        xyz = __klm
        type = .n_klm
    }

    init( _ str: String? ) {

        var components = str?.components(separatedBy: "_") ?? []
        let type_ = SymmetryCode_t.symmTypeFrom( components )

        type = type_

        if type_ == .n || type_ == .n_klm {
            if let symIdx = components.first {
                n = (symIdx as NSString).integerValue
            }
            else {
                n = nil
            }
        }
        else {
            n = nil
        }

        if type_ == .n_klm {
            if components.count > 1 {
                xyz = SymmetryCode_t.xyzFrom( klm: components[1] )
            }
            else {
                xyz = nil
            }
        }
        else {
            xyz = nil
        }

    }

    static func symmTypeFrom( _ str: [String] ) -> SymmetryCodeType {
        if str.first == nil {
            return .nothing
        }
        if str.first == "?" {
            return .q
        }
        if str.first == "." {
            return .dot
        }
        if str.count > 1 {
            return .n_klm
        }
        return .n
    }

    static func xyzFrom( klm: String ) -> LatticeCoord {
        func integerValue( _ str: NSString, idx: Int ) -> Int {
            let character : NSString = str.substring( with: NSRange( location: idx, length: 1 ) ) as NSString
            return character.integerValue
        }
        let klm : NSString = klm as NSString
        return LatticeCoord( integerValue( klm, idx: 0 ) - 5,
                             integerValue( klm, idx: 1 ) - 5,
                             integerValue( klm, idx: 2 ) - 5)
    }

    var string: String {
        switch type {
        case .dot:
            return "."
        case .n:
            return NSString(format: "%d",
                            n ?? 0) as String
        case .n_klm:
            return NSString(format: "%d_%d%d%d",
                            n ?? 0,
                            5+(xyz?.x ?? 0),
                            5+(xyz?.y ?? 0),
                            5+(xyz?.z ?? 0) ) as String
        default:
            return "?"
        }
    }

    var hasN: Bool {
        return (type == .n || type == .n_klm) && n != nil
    }
}

func dictionaryRepresentation( from symmetryCode: SymmetryCode_t ) -> [String:Any] {
    assert( symmetryCode.type == .n )
    return [ "n": symmetryCode.n! as Any, ]
}

func symmetryCode( with dictionaryRepresentation: [String:Any] ) -> SymmetryCode_t {
    return SymmetryCode_t( dictionaryRepresentation["n"] as! Int )
}










