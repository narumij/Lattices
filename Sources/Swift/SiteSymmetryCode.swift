//
//  SiteCondition.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

struct SiteSymmetryCode_t {

    let label: String?
    let symmetryCode: SymmetryCode_t

    var xyz : LatticeCoord {
        return symmetryCode.xyz ?? LatticeCoord(0,0,0)
    }

    var type : SymmetryCodeType {
        return symmetryCode.type
    }

    func isMatchNth( _ primeAtom: PrimeAtom_t ) -> Bool {
        return symmetryCode.n == primeAtom.symop.index || equivIndex( primeAtom.equivSymop, index: symmetryCode.n ?? 0 )
    }

    func nthCondition( _ primeAtom: PrimeAtom_t ) -> Bool {
        if symmetryCode.n != nil {
            return isMatchNth( primeAtom )
        }
        return true
    }

    func geomBondRightHandCondition( _ primeAtom: PrimeAtom_t ) -> Bool {

        if primeAtom.site.label != label {
            return false
        }

        switch symmetryCode.type {
        case .n:
            fallthrough
        case .n_klm:
            return primeAtom.symop.index == symmetryCode.n || equivIndex( primeAtom.equivSymop, index: symmetryCode.n ?? 0 )
        default:
            return true
        }
        
    }

    func geomHBondCondition( _ primeAtom: PrimeAtom_t ) -> Bool {
        #if false
            return primeAtom.site.label == siteLabel
        #else
            return geomBondRightHandCondition( primeAtom )
        #endif
    }

    func geomAngleCondition( _ primeAtom: PrimeAtom_t ) -> Bool {
        if primeAtom.site.label != label {
            return false
        }
        if symmetryCode.type != .n && symmetryCode.type != .n_klm {
            return true
        }
        return primeAtom.symop.index == symmetryCode.n || equivIndex( primeAtom.equivSymop, index: symmetryCode.n ?? 0 )
    }

    func geomAngleCondition( _ concreteAtom: ConcreteAtom_t ) -> Bool {
        if !geomAngleCondition( concreteAtom.primeAtom ) {
            return false
        }
        if symmetryCode.type == .n_klm {
            return concreteAtom.latticeCoord == symmetryCode.xyz
        }
        return true
    }

    func primeAtomCondition(_ p: PrimeAtom_t) -> Bool {
        return p.site.label == label && p.symop.index == symmetryCode.n
    }

    func primeAtomBondGroupCondition( _ g: PrimeAtomBondGroup_t ) -> Bool {
        return g.atoms.filter({self.primeAtomCondition($0)}).count > 0
    }
}

func dictionaryRepresentation( from siteSymmetryCode: SiteSymmetryCode_t ) -> [String:Any] {
    return [ "label": siteSymmetryCode.label! as Any,
             "symmetryCode": dictionaryRepresentation(from: siteSymmetryCode.symmetryCode )
    ]
}

func siteSymmetryCode( with dictionaryRepresentation: [String:Any] ) -> SiteSymmetryCode_t {
    return SiteSymmetryCode_t(
        label: dictionaryRepresentation["label"] as! String?,
        symmetryCode: symmetryCode(with:dictionaryRepresentation["symmetryCode"] as! [String:Any]) )
}


