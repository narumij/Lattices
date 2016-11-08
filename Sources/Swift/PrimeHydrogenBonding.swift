//
//  PrimeHydrogenBonding.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/24.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension PrimeCrystal_t {

    func generatePrimeAtomsWithPrimeBondsAndPrimeHydrogenBonds( cell: Cell_t,
                                                                sites:[Site_t],
                                                                aniso:[Aniso_t],
                                                                symop:[Symop_t],
                                                                geomBonds:[GeomBond_t],
                                                                geomHydrogenBonds:[GeomHBond_t],
                                                                cancelled : ()->Bool ) -> [PrimeAtom_t] {
        let primeAtoms = generatePrimeAtomsWithPrimeBonds( cell: cell,
                                                           sites: sites,
                                                           aniso: aniso,
                                                           symop: symop,
                                                           geomBonds: geomBonds,
                                                           cancelled: cancelled )

        debugPrint("prime hydrogen bonds")

        var offsets : [LatticeCoord] = []
        for i in [-1,0,1] {
            for j in [-1,0,1] {
                for k in [-1,0,1] {
                    offsets.append(LatticeCoord(i,j,k))
                }
            }
        }
        for hbond in geomHydrogenBonds {

            debugPrint( "\(hbond) D: \(hbond.atomSiteLabelD ?? "") H: \(hbond.atomSiteLabelH ?? "") A: \(hbond.atomSiteLabelA ?? "")" )

            var count = 0

            let conditionD = hbond.siteSymmetryCodeD
            let conditionH = hbond.siteSymmetryCodeH
            let conditionA = hbond.siteSymmetryCodeA

            let donars    = primeAtoms.filter{ conditionD.geomHBondCondition( $0 ) }
            let acceptors = primeAtoms.filter{ conditionA.geomHBondCondition( $0 ) }
            let hydrogens = primeAtoms.filter{ conditionH.geomHBondCondition( $0 ) }

            for h in hydrogens {

                let fractH = h.fract( LatticeCoordZero )
                let cartnH = h.cartn( LatticeCoordZero )
                let aabbDH = cell.fractionalAABB( fractionalCenter: fractH,
                                                  cartesianRadius: maximumValue(hbond.distanceDH) )
                let aabbHA = cell.fractionalAABB( fractionalCenter: fractH,
                                                  cartesianRadius: maximumValue(hbond.distanceHA) )

                for d in donars {

                    for offsetD in offsets {

                        if !(aabbDH?.contains(d.fract(offsetD)) ?? true) {
                            continue
                        }

                        let cartnD = d.cartn(offsetD)
                        if distance( cartnD, cartnH ) !~ hbond.distanceDH {
                            continue
                        }

                        for a in acceptors {

                            for offsetA in offsets {

                                if !(aabbHA?.contains(a.fract(offsetA)) ?? true) {
                                    continue
                                }

                                let cartnA = a.cartn(offsetA)
                                if distance( cartnH, cartnA ) !~ hbond.distanceHA {
                                    continue
                                }

                                if distance( cartnD, cartnA ) =~ hbond.distanceDA
                                    && angle( cartnD, apex: cartnH, to: cartnA ).toDegree =~ hbond.angleDHA {
                                    let phb = PrimeHydrogenBond_t(donar: d,
                                                                  hydrogen: h,
                                                                  acceptor: a,
                                                                  donarOffset: offsetD,
                                                                  acceptorOffset: offsetA,
                                                                  geomHBond: hbond)
                                    d.primeHydrogenBondsD.append( phb )
                                    h.primeHydrogenBondsH.append( phb )
                                    a.primeHydrogenBondsA.append( phb )
                                    count += 1
                                }
                            }
                        }
                    }
                }
            }
            debugPrint( "found \(count)" )
        }
        return primeAtoms
    }
    
}

