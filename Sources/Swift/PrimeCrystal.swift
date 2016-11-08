//
//  PrimeCrystal.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class PrimeCrystal_t {

    enum BondingMode {
        case off, on
    }

    var atoms: [PrimeAtom_t] = []
    var bonds: [PrimeBond_t] = []
    var occupancy: [PrimeAtomOccupancyGroup_t] = []
    var bondGroups: [PrimeAtomBondGroup_t] = []
    var bondingMode: BondingMode = .on

    var cancelled: Bool = false

    init() {
    }

    init( info i: CrystalInfo_t?, bonding p: BondingMode ) {
        bondingMode = p
        guard let info = i else {
            return
        }
        generatePrimeAtoms(info)
        generatePrimeAtomOccupancyGroups(info)

        debugPrint("------------------")
        debugPrint("prime crystal statics")
        debugPrint("------------------")
        debugPrint("atoms: \(atoms.count)")
        debugPrint("bonds: \(bonds.count)")
        debugPrint("occupancy: \(occupancy.count)")
        debugPrint("bondGroups: \(bondGroups.count)")
        debugPrint("")
    }

    func generatePrimeAtoms(_ info: CrystalInfo_t) {

        switch bondingMode {
        case .off:
            atoms = generatePrimeAtomsWithoutPrimeBonds( crystalInfo: info, cancelled: {
                [weak self] in return self?.cancelled ?? false } )
        case .on:
            #if true
                atoms = generatePrimeAtomsWithPrimeBonds( crystalInfo: info, cancelled: {
                    [weak self] in return self?.cancelled ?? false } )
            #else
                atoms = generatePrimeAtomsWithPrimeBondsAndPrimeHydrogenBonds( cell: cell, sites: sites, aniso: aniso, symop: symop, geomBonds: geomBonds, geomHydrogenBonds: geomHydrogenBonds, cancelled: { [weak self] in return self?.cancelled ?? false })
            #endif
        }

        if info.geomBonds.count > 0 {
            bondGroups = generatePrimeAtomBondGroups( atoms )
        }
    }

    func generatePrimeAtomOccupancyGroups(_ info: CrystalInfo_t) {
        let fracts = nub( atoms.map{ $0.fract(LatticeCoordZero) }, isEquivalent: { $0 =~ $1 } )
        occupancy = fracts
            .map({ (fract) in atoms.filter({ (atom) in atom.fract(LatticeCoordZero) =~ fract }) })
            .filter({ $0.count > 1 })
            .map({
                let group = PrimeAtomOccupancyGroup_t( atoms: $0 )
                _ = group.atoms.map({ $0.primeAtomOccupancyGroup = group })
                return group
            })
        debugPrint("occupancy \(occupancy.map({ $0.atoms.map({ $0.site.label }) as [String] }))")
    }

}



