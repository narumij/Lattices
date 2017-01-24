//
//  PrimeCrystal.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/28.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

typealias Cell_t = CrystalCell_t
typealias Site_t = CrystalAtomSite_t
typealias Symop_t = CrystalSymmetryOperation_t
typealias GeomBond_t = CrystalGeomBond_t
typealias GeomHBond_t = CrystalGeomHBond_t
typealias Aniso_t = CrystalAtomSiteAniso_t

class PrimeAtom_t {

    var site: Site_t
    var aniso: Aniso_t?

    var cell: Cell_t
    var symop: Symop_t
    var equivSymop: [Symop_t] = []
    var multiplicity: Int = 0

    var primeBonds: [PrimeBond_t] = []

    var primeHydrogenBondsD: [PrimeHydrogenBond_t] = []
    var primeHydrogenBondsH: [PrimeHydrogenBond_t] = []
    var primeHydrogenBondsA: [PrimeHydrogenBond_t] = []

    weak var primeAtomOccupancyGroup: PrimeAtomOccupancyGroup_t? = nil
    weak var primeAtomBondGroup: PrimeAtomBondGroup_t? = nil
    var primeAtomBondGroupCoord: LatticeCoord = LatticeCoordZero

    init( cell c: Cell_t,
          site s: Site_t,
          aniso a: Aniso_t?,
          symop sy: Symop_t,
          allSymop: [Symop_t] ) {
        cell = c
        site = s
        symop = sy
        aniso = a
        equivSymop = allSymop.filter{ $0.clamped(site) =~ clamped }
        eigen = self.generateEigen()
//        prepareCartnCache()
    }

    var isIdentity: Bool {
        return symop.isIdentity
    }

    var clamped: Vector3 {
        return symop.clamped(site)
    }

    func fract( _ latticeCoord: LatticeCoord ) -> Vector3 {
        return clamped + vector_float( latticeCoord )
    }

//    var cartnCache: [LatticeCoord:Vector3] = [:]
//
//    func prepareCartnCache() {
//        let offsets = latticeCoordFullOffsets()
//        offsets.forEach {
//            cartnCache[$0] = primitiveCartn($0)
//        }
//    }

    fileprivate func primitiveCartn( _ latticeCoord: LatticeCoord ) -> Vector3 {
//        return (cell.matrix4x4 * vector4( fract(latticeCoord), 1 ) ).xyz
        return cell.toCartn( fract: fract( latticeCoord ) )
    }

    func cartn( _ latticeCoord: LatticeCoord ) -> Vector3 {
//        if let c = cartnCache[latticeCoord] {
//            return c
//        }
        return primitiveCartn( latticeCoord )
    }

    func equiv( _ atom: PrimeAtom_t ) -> Bool {
        return site === atom.site && ( fract(LatticeCoordZero) =~ atom.fract(LatticeCoordZero) )
    }

    func ConcreteAtom( _ latticeCoord: LatticeCoord ) -> ConcreteAtom_t {
        return ConcreteAtom_t( primeAtom: self, latticeCoord: latticeCoord )
    }

    fileprivate func anisoU() -> CartU_t? {
        return aniso?.U == nil ? nil : cell.CartUFromUani(aniso!.U!)
    }

    fileprivate func anisoB() -> CartU_t? {
        return aniso?.B == nil ? nil : cell.CartUFromUani(cell.UaniFromBani(aniso!.B!))
    }

    fileprivate func isoU() -> CartU_t? {
        return site.Uiso?.CartU
    }

    fileprivate func isoB() -> CartU_t? {
        return site.Biso == nil ? nil : cell.UisoFromBiso(site.Biso!).CartU
    }

    var cartU : CartU_t? {
        if let adpType = site.adpType {
            switch adpType {
            case .Uani:
                return anisoU()
            case .Uiso:
                return isoU()
            case .Bani:
                return anisoB()
            case .Biso:
                return isoB()
            case .Bovl:
                return nil
            case .Uovl:
                return nil
            case .Umpe:
                return nil
            }
        }
        return anisoU() ?? anisoB() ?? isoU() ?? isoB()
    }

    var isIsotropic : Bool {
        if let adpType = site.adpType {
            switch adpType {
            case .Uiso:
                return true
            case .Biso:
                return true
            case .Uani:
                return false
            case .Bani:
                return false
            case .Bovl:
                return false
            case .Uovl:
                return false
            case .Umpe:
                return false
            }
        }
        return ( anisoU() == nil && anisoB() == nil ) && ( isoU() != nil || isoB() != nil )
    }

    func generateEigen() -> Float3x3Eigen {
        if let mat = cartU {
            return Float3x3Eigen( mat.cmatrix )
        }
        return Float3x3Eigen.identity
    }

    var eigen : Float3x3Eigen = Float3x3Eigen.identity

    var symopRotate : Matrix4x4 {
        let b = ( ( cell.matrix3x3 ) )
        var m = Matrix4x4From3x3( cell.isHexagonal ? b * symop.matrix3x3 * b.inverse : symop.matrix3x3 )
        if symop.matrix3x3.determinant < 0 {
            m[3,3] = -1
        }
        return m
    }

    func isotropicAdjust( _ m: SCNMatrix4 ) -> SCNMatrix4 {
        if !isIsotropic { return m }
        let c = normalize(cell.cVector)
        let b = cross( c, cross( c, normalize(cell.bVector) ) )
        let z = SCNVector3(0,0,1)
        let y = SCNVector3(0,1,0)
//        let quat = SCNQuaternion.ModelLookUp( fromLook: z, fromUp: y, toLook: c.scn, toUp: b.scn )
        let quat = SCNQuaternion( from:( z, y ), to:( c.scn, b.scn ) )
        return SCNMatrix4(quat:quat) * m;
    }

    var ellipsoidNode0Transform : SCNMatrix4 {
        return isotropicAdjust( SCNMatrix4( symopRotate * eigen.matrix4x4 ) )
    }

    var ellipsoidNode1Scale : SCNVector3 {
        return eigen.ellipsoidScale.scn
    }

    var siteSymmetryCode: SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: site.label, symmetryCode: SymmetryCode_t(symop.index) )
    }
}

func ==( l: PrimeAtom_t, r: PrimeAtom_t ) -> Bool {
    return l === r
}

extension PrimeAtom_t : Equatable {
}

func < (l:PrimeAtom_t,r:PrimeAtom_t) -> Bool {
    return l.site < r.site || ( l.site == r.site && l.symop.index < r.symop.index )
}

func > (l:PrimeAtom_t,r:PrimeAtom_t) -> Bool {
    return l.site > r.site || ( l.site == r.site && l.symop.index > r.symop.index )
}

class PrimeAtomOccupancyGroup_t {
    let atoms: [PrimeAtom_t]
    init( atoms a: [PrimeAtom_t] ) {
        atoms = a
    }
}

typealias PrimeAtomAndCoord = (atom:PrimeAtom_t?,coord:LatticeCoord)

class PrimeAtomBondGroup_t {

    let index: Int
    let atoms: [PrimeAtom_t]
    var positions: [ LatticeCoord : [PrimeAtom_t] ] = [ : ]

    var publFlag : Bool = true

    init() {
        index = 0
        atoms = []
    }

    init( index i: Int, atoms a: [PrimeAtom_t] ) {
        index = i
        atoms = a
        preparePositions()
    }

}

func dictionaryRepresentation( from bondGroup: PrimeAtomBondGroup_t ) -> [String:Any] {
    assert( bondGroup.atoms.count > 0 )
    return ["publFlag":bondGroup.publFlag as Any,
            "anyCode": dictionaryRepresentation( from: bondGroup.atoms.first!.siteSymmetryCode ) as Any
    ]
}

func primeAtomGroupIndex( from bondRep: [String:Any] ) -> (publFlag:Bool,anyCode:SiteSymmetryCode_t) {
    return (bondRep["publFlag"] as! Bool,
            siteSymmetryCode(with:bondRep["anyCode"] as! [String:Any]))
}

func ==( l: PrimeAtomBondGroup_t, r: PrimeAtomBondGroup_t ) -> Bool {
    return l === r
}

extension PrimeAtomBondGroup_t : Equatable {
}

func < (l:PrimeAtomBondGroup_t,r:PrimeAtomBondGroup_t) -> Bool {
    return l.atoms.count < r.atoms.count
}

func > (l:PrimeAtomBondGroup_t,r:PrimeAtomBondGroup_t) -> Bool {
    return l.atoms.count > r.atoms.count
}


class PrimeBond_t {
    weak var left: PrimeAtom_t?
    weak var right: PrimeAtom_t?
    var leftLatticeCoord : LatticeCoord?
    var rightOffset: LatticeCoord = LatticeCoord(0,0,0)
    var geomBond: GeomBond_t
    init( left: PrimeAtom_t?, right: PrimeAtom_t?, rightOffset: LatticeCoord, geomBond: GeomBond_t ) {
        self.left = left
        self.right = right
        self.rightOffset = rightOffset
        self.geomBond = geomBond
    }
    func equiv( _ rhs: PrimeBond_t ) -> Bool {
        if left === rhs.left && right === rhs.right && rightOffset == rhs.rightOffset {
            return true
        }

        if left === rhs.right && right === rhs.left && rightOffset == -(rhs.rightOffset) {
            return true
        }

        return false
    }
    func oppositionOf( _ atom: PrimeAtom_t? ) -> PrimeAtomAndCoord {
        if atom === left {
            return ( right, rightOffset )
        }
        if atom === right {
            return ( left, -rightOffset )
        }
        return ( nil, LatticeCoordZero )
    }
}

extension PrimeAtom_t {
    var oppositions: [PrimeAtomAndCoord] {
        return primeBonds.map{ $0.oppositionOf(self) }
    }
}


class PrimeHydrogenBond_t {
    weak var donar: PrimeAtom_t?
    weak var hydrogen: PrimeAtom_t?
    weak var acceptor: PrimeAtom_t?
    var donarLatticeCoord: LatticeCoord?
    var acceptorLatticeCoord: LatticeCoord?
    var geomHBond:GeomHBond_t
    init( donar d: PrimeAtom_t?, hydrogen h: PrimeAtom_t?, acceptor a: PrimeAtom_t?,
          donarOffset dOffset: LatticeCoord?, acceptorOffset aOffset: LatticeCoord?,
          geomHBond g: GeomHBond_t ) {
        donar = d
        hydrogen = h
        acceptor = a
        donarLatticeCoord = dOffset
        acceptorLatticeCoord = aOffset
        geomHBond = g
    }
}


func equivIndex( _ equiv:[Symop_t], index: Int ) -> Bool {
    return equiv.filter{ $0.index == index }.count > 0
}

func generatePrimeAtomsWithoutPrimeBonds( crystalInfo: CrystalInfo_t,
                                          cancelled : ()->Bool ) -> [PrimeAtom_t] {
    return generatePrimeAtomsWithoutPrimeBonds(cell: crystalInfo.cell,
                                               sites: crystalInfo.sites,
                                               aniso: crystalInfo.aniso,
                                               symop: crystalInfo.symop,
                                               geomBonds: crystalInfo.geomBonds,
                                               cancelled: cancelled )
}

func generatePrimeAtomsWithoutPrimeBonds( cell: Cell_t,
                                          sites:[Site_t],
                                          aniso:[Aniso_t],
                                          symop:[Symop_t],
                                          geomBonds:[GeomBond_t],
                                          cancelled : ()->Bool ) -> [PrimeAtom_t] {
    var primeAtoms : [PrimeAtom_t] = []

    func matchAniso( _ site: Site_t ) -> Aniso_t? {
        return aniso.filter( { $0.isMatch( with: site ) } ).first
    }

    for (i,site) in sites.enumerated() {

        if cancelled() {
            debugPrint("cancel in generatePrimeAtomsWithoutPrimeBonds")
            break
        }

        let atoms = symop.map {
            PrimeAtom_t( cell: cell, site: site, aniso: matchAniso(site), symop: $0, allSymop: symop )
        }

        let hogeAtoms = nub( atoms, isEquivalent: { $0.equiv($1) } )

        _ = hogeAtoms.map{
            $0.multiplicity = hogeAtoms.count
        }

        primeAtoms.append( contentsOf: hogeAtoms )

        postProgressKey( .PrimeAtom, progress: Double(i) / Double(sites.count) )

    }
    return primeAtoms
}










