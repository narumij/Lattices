//
//  ConcreteCrystal.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/20.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class ConcreteAtom_t {
    var primeAtom : PrimeAtom_t
    var latticeCoord : LatticeCoord = LatticeCoordZero
    var bonds : [ConcreteBond_t] = []
    var hydrogenBondsD : [ConcreteHydrogenBond_t] = []
    var hydrogenBondsH : [ConcreteHydrogenBond_t] = []
    var hydrogenBondsA : [ConcreteHydrogenBond_t] = []
    var chainBondingStep : Int = 0
    var node : SCNNode?

    var bondingCount : Int {
        return bonds.count
    }

    init( primeAtom : PrimeAtom_t ) {
        self.primeAtom = primeAtom
    }

    init( primeAtom: PrimeAtom_t, latticeCoord: LatticeCoord ) {
        self.primeAtom = primeAtom
        self.latticeCoord = latticeCoord
    }

    var isIdentity: Bool {
        return primeAtom.isIdentity && latticeCoord == LatticeCoordZero
    }

    var siteLabel : String {
        return primeAtom.site.label
    }

    var atomicSymbol : AtomicSymbol {
        return primeAtom.site.atomicSymbol
    }

    var fract : Vector3 {
        return primeAtom.fract( latticeCoord )
    }

    var cartn : Vector3 {
        return primeAtom.cartn( latticeCoord )
    }

    var siteSymmetry: SymmetryCode_t {
        return SymmetryCode_t( primeAtom.symop.index, latticeCoord )
    }

//    var cartnCoord : CartnCoord_t {
//        return CartnCoord_t( cartn )
//    }

    func equiv(_ atom:ConcreteAtom_t) -> Bool {
        return primeAtom === atom.primeAtom && latticeCoord == atom.latticeCoord
    }

    var show : String {
        return "Atom label:"+siteLabel+" symbol:"+atomicSymbol.rawValue+" "+fract.show+" "+cartn.show+" (\(latticeCoord.x),\(latticeCoord.y),\(latticeCoord.z))"
    }

    func hasEquivBond( _ prime: PrimeBond_t ) -> Bool {
        return bonds.filter{ $0.primeBond.equiv(prime) }.count > 0
    }

    var isUniquePosition : Bool {
        if primeAtom.primeAtomBondGroup?.publFlag == false {
            return false
        }
        return latticeCoord == primeAtom.primeAtomBondGroupCoord
    }
}

class ConcreteAngle_t {
    var atom1: ConcreteAtom_t?
    var atom2: ConcreteAtom_t?
    var atom3: ConcreteAtom_t?
    var cartn1 : Vector3 { return atom1?.cartn ?? Vector3Zero }
    var cartn2 : Vector3 { return atom2?.cartn ?? Vector3Zero }
    var cartn3 : Vector3 { return atom3?.cartn ?? Vector3Zero }
    var geomAngle: CrystalGeomAngle_t
    init( atom1 a1: ConcreteAtom_t, atom2 a2: ConcreteAtom_t, atom3 a3: ConcreteAtom_t, geomAngle g: CrystalGeomAngle_t ) {
        atom1 = a1
        atom2 = a2
        atom3 = a3
        geomAngle = g
    }
}

class ConcreteBond_t {
    var left : ConcreteAtom_t?
    var right : ConcreteAtom_t?
    var cartn1 : Vector3 { return left?.cartn ?? Vector3Zero }
    var cartn2 : Vector3 { return right?.cartn ?? Vector3Zero }
    var atom1 : ConcreteAtom_t { return left! }
    var atom2 : ConcreteAtom_t { return right! }
    var primeBond : PrimeBond_t
    var nodes : [SCNNode] = []
    init( left l: ConcreteAtom_t?, right r: ConcreteAtom_t?, prime p: PrimeBond_t ) {
        left = l
        right = r
        primeBond = p
    }
    var chainBondingStep : Int {
        return max( left?.chainBondingStep ?? 0, right?.chainBondingStep ?? 0 )
    }
    var center: Vector3 {
        return (cartn1+cartn2)*Vector3(0.5)
    }
}

class ConcreteContact_t {
    var atom1: ConcreteAtom_t?
    var atom2: ConcreteAtom_t?
    var cartn1 : Vector3 { return atom1?.cartn ?? Vector3Zero }
    var cartn2 : Vector3 { return atom2?.cartn ?? Vector3Zero }
    var geomContact: CrystalGeomContact_t
    init( atom1 a1: ConcreteAtom_t, atom2 a2: ConcreteAtom_t, geomContact g: CrystalGeomContact_t ) {
        atom1 = a1
        atom2 = a2
        geomContact = g
    }
}

class ConcreteHydrogenBond_t {
    var donar : ConcreteAtom_t?
    var hydrogen : ConcreteAtom_t
    var acceptor : ConcreteAtom_t?
    init( donar d: ConcreteAtom_t?, hydrogen h: ConcreteAtom_t, acceptor a: ConcreteAtom_t ) {
        donar = d
        hydrogen = h
        acceptor = a
    }
    var chainBondingStep : Int {
        return hydrogen.chainBondingStep
    }
}

class ConcreteTorsion_t {
    var atom1: ConcreteAtom_t?
    var atom2: ConcreteAtom_t?
    var atom3: ConcreteAtom_t?
    var atom4: ConcreteAtom_t?
    var cartn1 : Vector3 { return atom1?.cartn ?? Vector3Zero }
    var cartn2 : Vector3 { return atom2?.cartn ?? Vector3Zero }
    var cartn3 : Vector3 { return atom3?.cartn ?? Vector3Zero }
    var cartn4 : Vector3 { return atom4?.cartn ?? Vector3Zero }
    var geomTorsion: CrystalGeomTorsion_t
    init( atom1 a1: ConcreteAtom_t, atom2 a2: ConcreteAtom_t, atom3 a3: ConcreteAtom_t, atom4 a4: ConcreteAtom_t, geomAngle g: CrystalGeomTorsion_t ) {
        atom1 = a1
        atom2 = a2
        atom3 = a3
        atom4 = a4
        geomTorsion = g
    }
}







