//
//  PrimeBonding.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/23.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension PrimeCrystal_t {

    func generatePrimeAtomsWithPrimeBonds( crystalInfo: CrystalInfo_t,
                                           cancelled : ()->Bool ) -> [PrimeAtom_t] {
        return generatePrimeAtomsWithPrimeBonds(cell: crystalInfo.cell,
                                                sites: crystalInfo.sites,
                                                aniso: crystalInfo.aniso,
                                                symop: crystalInfo.symop,
                                                geomBonds: crystalInfo.geomBonds,
                                                cancelled: cancelled )
    }

    func generatePrimeAtomsWithPrimeBonds( cell: Cell_t,
                                           sites:[Site_t],
                                           aniso:[Aniso_t],
                                           symop:[Symop_t],
                                           geomBonds:[GeomBond_t],
                                           cancelled : ()->Bool ) -> [PrimeAtom_t] {

        // prime atom 生成
        let primeAtoms = generatePrimeAtomsWithoutPrimeBonds( cell: cell,
                                                              sites: sites,
                                                              aniso: aniso,
                                                              symop: symop,
                                                              geomBonds: geomBonds,
                                                              cancelled: cancelled )

        // prime bond 生成 ここから

        // offset生成
        #if true
            let offsets = latticeCoordFullOffsets()
        #else
        var offsets : [LatticeCoord] = []
        for i in [-1,0,1] {
            for j in [-1,0,1] {
                for k in [-1,0,1] {
                    offsets.append(LatticeCoord(i,j,k))
                }
            }
        }
        #endif

        let time0 = CFAbsoluteTimeGetCurrent()

        for ( i, leftAtom ) in primeAtoms.enumerated() {
            if cancelled() {
                debugPrint("cancel in generatePrimeAtomsWithPrimeBonds")
                break
            }

            // ボンドをラベルで絞り込み、左手側の原子がタプルの左側になるように整形
            let bonds = geomBonds
                .filter{ $0.atomSiteLabel1 == leftAtom.site.label || $0.atomSiteLabel2 == leftAtom.site.label }
                .map{ $0.atomSiteLabel1 == leftAtom.site.label
                    ? ( left: $0.siteSymmetryCode1, right: $0.siteSymmetryCode2, geomBond: $0 )
                    : ( left: $0.siteSymmetryCode2, right: $0.siteSymmetryCode1, geomBond: $0 ) }

            // チェック予定のボンド数と同じだけ、既にボンドが張られている場合、スキップ
            if leftAtom.primeBonds.count == bonds.count {
                continue
            }

            for ( leftCond, rightCond, geomBond ) in bonds {

                // 既に該当するボンドが張られている場合、スキップ
                if leftAtom.primeBonds.filter( { $0.geomBond === geomBond } ).count > 0 {
                    continue
                }

                // 対称要素が該当しない場合、スキップ
                if !leftCond.nthCondition( leftAtom ) {
                    continue
                }

                let rightAtoms = primeAtoms.filter{ rightCond.geomBondRightHandCondition($0) }

                // 両側が絶対指定だった場合はボンドを張ってスキップ
                if rightCond.type == .n_klm && leftCond.type == .n_klm {

                    // 左原子にボンドを張る
                    let leftbondoffset = rightCond.xyz - leftCond.xyz
                    let leftbond = PrimeBond_t( left: leftAtom, right: rightAtoms.first!, rightOffset: leftbondoffset, geomBond: geomBond )
                    leftbond.leftLatticeCoord = leftCond.xyz
                    leftAtom.primeBonds.append( leftbond )

                    // 右原子にボンドを張る
                    let rightbondoffset = leftCond.xyz - rightCond.xyz
                    let rightbond = PrimeBond_t( left: rightAtoms.first!, right: leftAtom, rightOffset: rightbondoffset, geomBond: geomBond )
                    rightbond.leftLatticeCoord = rightCond.xyz
                    rightAtoms.first?.primeBonds.append(rightbond)

                    continue
                }

                // 反対側が絶対指定だった場合はスキップ
                if rightCond.type == .n_klm {
                    continue
                }

                for rightAtom in rightAtoms {

                    var offsets = offsets.map{ ( $0, rightAtom.fract($0) ) }

                    if let aabb = cell.fractionalAABB( fractionalCenter: leftAtom.fract(LatticeCoordZero),
                                                       cartesianRadius: maximumValue(geomBond.distance) ) {
//                        offsets = offsets.filter{ aabb.contains($0.1) }
                        offsets = offsets.filter{ aabb.fractionalContains($0.1) }
                    }

                    for (offset,_) in offsets {

                        assert( distance( leftAtom.cartn( LatticeCoordZero ), rightAtom.cartn( offset ) )
                            =~~ cell.distance( leftAtom.fract( LatticeCoordZero ), rightAtom.fract( offset ) ) )

//                        if geomBond.distance! =~ distance( leftAtom.cartn( LatticeCoordZero ), rightAtom.cartn( offset ) ) {
                        if geomBond.distance! =~ cell.distance( leftAtom.fract( LatticeCoordZero ), rightAtom.fract( offset ) ) {

                            // 右原子にボンドを張る
                            // 絶対指定だった場合には、格子座標をセット
                            let leftbond = PrimeBond_t( left: leftAtom, right: rightAtom, rightOffset: offset, geomBond: geomBond )
                            if leftCond.type == .n_klm {
                                leftbond.leftLatticeCoord = leftCond.xyz
                            }
                            leftAtom.primeBonds.append( leftbond )
                            
                            // 左原子にボンドを張る
                            // 片側が絶対指定だった場合は張らない
                            if leftCond.type != .n_klm {
                                let rightbond = PrimeBond_t( left: rightAtom, right: leftAtom, rightOffset: -offset, geomBond: geomBond )
                                rightAtom.primeBonds.append( rightbond )
                            }
                            
                        }
                        
                    }
                }
                
            }
            postProgressKey( .PrimeBond, progress: Double(i)/Double(primeAtoms.count))
        }
        
        debugPrint("prime bond generate time = \(CFAbsoluteTimeGetCurrent() - time0)")
        
        return primeAtoms
    }
    
}

