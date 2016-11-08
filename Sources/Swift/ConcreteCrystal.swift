//
//  ConcreteCrystal.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class ConcreteCrystal_t {

    var atoms:  [ConcreteAtom_t] = []
    var bonds:  [ConcreteBond_t] = []
    var hbonds: [ConcreteHydrogenBond_t] = []
    var angles: [ConcreteAngle_t] = []

    var bondingRangeCountRate = DefaultBondingRangeCountRate
    static var DefaultBondingRangeCountRate : Int = 10

    enum BondingMode {
        case off, on
    }
    var bondingMode : BondingMode = .on

    init() {
    }

    init( prime: PrimeCrystal_t, bonding p: BondingMode ) {
        bondingMode = p
        generateUnitCellAtoms(prime)
        if bondingMode != .off {
            generateBond(prime)
        }
    }

    func generateUnitCellAtoms(_ prime: PrimeCrystal_t ) {
        atoms = []

        let aabb = AABB_t( origin: vector3(0), size: vector3(1) )

        var offsets : [LatticeCoord] = []
        for i in [0,1] {
            for j in [0,1] {
                for k in [0,1] {
                    offsets.append(LatticeCoord(i,j,k))
                }
            }
        }

        for (i,primeAtom) in prime.atoms.enumerated() {
            let newAtoms = offsets
                .map{ primeAtom.ConcreteAtom( $0 ) }
                .filter{ aabb.contains( $0.fract ) }
            atoms = atoms + newAtoms
            postProgressKey(.ConcreteAtom,progress:(Double(i)/Double(prime.atoms.count)))
        }

    }

    func generateBond(_ prime: PrimeCrystal_t ) {

        bonds = []

        var restAtoms = atoms

        var increaseAtomCount : Int = 0
        let increaseAtomCountLimit = prime.atoms.count * bondingRangeCountRate

        #if true
            let increaseAtomEnable = bondingMode != .off
        #else
            let increaseAtomEnable = bondingRangeMode != .Nothing && bondingRangeMode != .UnitCell
        #endif

        while restAtoms.count > 0 {
            let left = restAtoms.first!
            restAtoms.removeFirst()

            #if true
                // チェーンボンドの上限を外す際に考慮すべきポイント
                if left.chainBondingStep >= 32 {
                    continue
                }
            #else
                switch bondingRangeMode {
                case .OneStep:
                    if left.chainBondingStep > 0 {
                        continue
                    }
                case .Limited:
                    if left.chainBondingStep >= 32 {
                        continue
                    }
                default:
                    break
                }
            #endif

            for bond in left.primeAtom.primeBonds {

                // ボンドをもっていた場合はスキップ

                if left.hasEquivBond( bond ) {
                    continue
                }

                if let latticeCoord = bond.leftLatticeCoord {
                    if left.latticeCoord != latticeCoord {
                        continue
                    }
                }

                var right = atoms
                    .filter{ $0.primeAtom === bond.right && $0.latticeCoord == (left.latticeCoord + bond.rightOffset) }
                    .first

                if increaseAtomEnable
                    && right == nil
                    && increaseAtomCount < increaseAtomCountLimit
                {
                    increaseAtomCount = increaseAtomCount + 1
                    let newAtom = bond.right!.ConcreteAtom( left.latticeCoord + bond.rightOffset )
                    newAtom.chainBondingStep = left.chainBondingStep + 1
                    restAtoms.append(newAtom)
                    atoms.append(newAtom)
                    right = newAtom
                }

                if right != nil {
                    let newBond : ConcreteBond_t = ConcreteBond_t( left: left, right: right, prime: bond )
                    left.bonds.append(newBond)
                    right!.bonds.append(newBond)
                    bonds.append( newBond )
                    if right?.primeAtom.primeBonds.count == 1 {
                        restAtoms = restAtoms.filter{ $0 !== right }
                    }
                }
            }
            postProgressKey(.ConcreteBond,progress:(Double(atoms.count - restAtoms.count)/Double(atoms.count)))
        }
        //        postProgressKey("ConcreteBond", progress: 1.0)

        debugPrint("------------------")
        debugPrint("concrete crystal statics")
        debugPrint("------------------")
        debugPrint("bond count = \(bonds.count)")
        debugPrint("prime atom count = \(prime.atoms.count)")
        debugPrint("additional atom count = \(increaseAtomCount)")
        debugPrint("")
    }

    #if false
    func generateConcreteHydrogenBond() {
        debugPrint("concrete hydrogen bonds")
        for hbond in info.geomHydrogenBonds {
            var count = 0

            let conditionD = hbond.siteSymmetryCodeD
            let conditionH = hbond.siteSymmetryCodeH
            let conditionA = hbond.siteSymmetryCodeA
            let donars = atoms.filter{ conditionD.geomHBondCondition( $0.primeAtom ) }
            let acceptors = atoms.filter{ conditionA.geomHBondCondition( $0.primeAtom ) }
            let hydrogens = atoms.filter{ conditionH.geomHBondCondition( $0.primeAtom ) }
            debugPrint( "\(hbond) D: \(hbond.atomSiteLabelD ?? "")-\(donars.count) H: \(hbond.atomSiteLabelH ?? "")-\(hydrogens.count) A: \(hbond.atomSiteLabelA ?? "")-\(acceptors.count)" )
            for h in hydrogens {
                let donars = donars.filter{ distance( h.cartn, $0.cartn ) =~ hbond.distanceDH! }
                let acceptors = acceptors.filter{ distance( h.cartn, $0.cartn ) =~ hbond.distanceHA! }
                for d in donars {
                    for a in acceptors {
                        if distance( d.cartn, a.cartn ) =~ hbond.distanceDA
                            && angle( d.cartn, apex: h.cartn, to: a.cartn ).toDegree =~ hbond.angleDHA
                        {
                            let hb = ConcreteHydrogenBond_t(donar: d, hydrogen: h, acceptor: a )
                            hbonds.append( hb )
                            d.hydrogenBondsD.append( hb )
                            h.hydrogenBondsH.append( hb )
                            a.hydrogenBondsA.append( hb )
                            count += 1
                        }
                    }
                }
            }
            debugPrint( "found \(count)" )
        }
        postProgressKey( .ConcreteHydrogenBond, progress: 1.0)
    }

    func generateConcreteAngles() {
        for (i,geomAngle) in info.geomAngles.enumerated() {
            var count = 0
            var count1 = 0
            var count2 = 0
            let condition1 = geomAngle.siteCondition1
            let condition2 = geomAngle.siteCondition2
            let condition3 = geomAngle.siteCondition3
            let lefts = atoms.filter{ condition1.geomAngleCondition( $0 ) }
            let apexes = atoms.filter{ condition2.geomAngleCondition( $0 ) }
            let rights = atoms.filter{ condition3.geomAngleCondition( $0 ) }
            debugPrint( "\(i), \(geomAngle) 1: \(geomAngle.atomSiteLabel1 ?? "")-\(lefts.count) 2: \(geomAngle.atomSiteLabel2 ?? "")-\(apexes.count) 3: \(geomAngle.atomSiteLabel3 ?? "")-\(rights.count)" )
            for apex in apexes {
                for d in lefts {
                    for a in rights {
                        //                        if apex.latticeCoord != LatticeCoordZero && d.latticeCoord != LatticeCoordZero && apex.latticeCoord != LatticeCoordZero {
                        //                            continue
                        //                        }
                        #if false
                            let an = angle( d.cartn, apex: apex.cartn, to: a.cartn ).toDegree
                            let an1 = angle( apex.cartn, apex: d.cartn, to: a.cartn ).toDegree
                            let an2 = angle( apex.cartn, apex: a.cartn, to: d.cartn ).toDegree
                        #else
                            let an = info.cell.angle( d.fract, apexFract: apex.fract, toFract: a.fract ).toDegree
                            let an1 = info.cell.angle( apex.fract, apexFract: d.fract, toFract: a.fract ).toDegree
                            let an2 = info.cell.angle( apex.fract, apexFract: a.fract, toFract: d.fract ).toDegree

                            let an_ = angle( d.cartn, apex: apex.cartn, to: a.cartn ).toDegree
                            let an1_ = angle( apex.cartn, apex: d.cartn, to: a.cartn ).toDegree
                            let an2_ = angle( apex.cartn, apex: a.cartn, to: d.cartn ).toDegree

                            assert(abs(an-an_)<0.1)
                            assert(abs(an1-an1_)<0.1)
                            assert(abs(an2-an2_)<0.1)

                        #endif
                        //                        if i == 6 {
                        //                            debugPrint("angle: \(an)")
                        //                        }
                        if an.toDegree =~ geomAngle.angle
                        {
                            //                            let a = ConcreteAngle_t(atom1: d, atom2: apex, atom3: a, geomAngle: geomAngle )
                            //                            angles.append( a )
                            count += 1
                        }

                        if an1.toDegree =~ geomAngle.angle
                        {
                            //                            let a = ConcreteAngle_t(atom1: apex, atom2: d, atom3: a, geomAngle: geomAngle )
                            //                            angles.append( a )
                            count1 += 1
                        }
                        
                        if an2.toDegree =~ geomAngle.angle
                        {
                            //                            let a = ConcreteAngle_t(atom1: apex, atom2: a, atom3: d, geomAngle: geomAngle )
                            //                            angles.append( a )
                            count2 += 1
                        }
                    }
                }
            }
            debugPrint( "found \(count) - \(count1) - \(count2)" )
        }
    }
    #endif
}

