//
//  CrystalInfo.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class CrystalInfo_t {
    init() {
    }
    init( cifData c: CIF ) {
        guard let crystalData = c.firstCrystal else {
            return
        }
        updateCrystalInformation(crystalData)
    }

    // MARK: -

    var cell : CrystalCell_t = CrystalCell_t()
    var _symop : [CrystalSymmetryOperation_t] = []
    var symop : [CrystalSymmetryOperation_t] {
        return _symop.count > 0 ? _symop : [CrystalSymmetryOperation_t( XYZ: "x,y,z", index: 1 )]
    }

    var hasDisplacement : Bool {
        if aniso.count > 0 { return true }
        return sites.filter( { $0.Biso != nil || $0.Uiso != nil }).count > 0
    }

    var symopHasProblem: Bool {
        return _symop.count == 0
    }

    func readCell( _ crystalData: CIFData ) {
        let tags : [CrystalCell_t.CIFTag] = [ .A, .B, .C, .Alpha, .Beta, .Gamma ]
        cell = CrystalCell_t( crystalData.floatType(tags) )
        cell.setting = crystalData.string("_symmetry_cell_setting")
    }

    func readSymop( _ crystalData: CIFData ) {
        _symop = []
        typealias CIFTag = CrystalSymmetryOperation_t.CIFTag
        let equivTags : [CIFTag] = [ .PosAsXYZ, .OperationXYZ ]
        _ = crystalData.loopQuery( equivTags, mainTag: nil ).enumerated().map{
            ( i, values ) in
            if let xyz = values[ .PosAsXYZ ] ?? values[ .OperationXYZ ] {
                let s : CrystalSymmetryOperation_t = CrystalSymmetryOperation_t( XYZ:xyz, index: i + 1 )
                _symop.append(s);
            }
        }
        if ( _symop.count == 0 ) {
            func first( _ values: [CIFTag:String]?, tags: [CIFTag] ) -> String? {
                if let values = values {
                    for tag in tags {
                        if let value = values[tag] {
                            return value
                        }
                    }
                }
                return nil
            }
            let hallTags : [CIFTag] = [ .symHM, .Hall, .HMAlt ]
            let hmTags : [CIFTag] = [ .symHall, .Hall ]

            let matrices = matricesFromSpacegroupName3(
                hall: crystalData.firstString(hallTags),
                hm: crystalData.firstString(hmTags) )

            for (i,mat) in matrices.enumerated() {
                let s = CrystalSymmetryOperation_t(matrix: mat,index:i+1)
                s.replaced = true
                _symop.append(s);
            }

            debugPrint("----------------------------")
            debugPrint("recoverd symmetry operations")
            debugPrint("                            ")
            _symop.forEach {
                debugPrint("(\($0.index)) \($0.xyz)")
            }
            debugPrint("----------------------------")
        }
//        if _symop.count == 0 {
//            _symop.append( CrystalSymmetryOperation(XYZ: "x,y,z", index: 1) )
//        }
    }

    func readCrystalItems<T:CIFTagInit>( _ crystalData: CIFData, _ tags: [T.CIFTag], mainTag: T.CIFTag? ) -> [T] where
        T.CIFTag:RawRepresentable,
        T.CIFTag:CIFTagAll,
        T.CIFTag.RawValue == String {

            func readTags<E: RawRepresentable>( _ tags: [E], mainTag: E? ) -> [[E:String]] where E.RawValue == String {
                return crystalData.loopQuery( tags, mainTag: mainTag )
            }

            return readTags( T.CIFTag.All, mainTag: mainTag ).map{ T( $0 ) }
    }

    var sites : [CrystalAtomSite_t] = []
    func readSites( _ crystalData: CIFData ) {
        sites = readCrystalItems( crystalData, CrystalAtomSite_t.CIFTag.All, mainTag: nil )
        _ = sites.enumerated().map{ $0.element.index = $0.offset }
    }

    var types : [CrystalAtomType_t] = []
    func readTypes( _ crystalData: CIFData ) {
        types = readCrystalItems( crystalData, CrystalAtomType_t.CIFTag.All, mainTag: nil )
    }

    var aniso : [CrystalAtomSiteAniso_t] = []
    func readAniso( _ crystalData: CIFData ) {
        aniso = readCrystalItems( crystalData, CrystalAtomSiteAniso_t.CIFTag.All, mainTag: CrystalAtomSiteAniso_t.CIFTag.Label )
    }

    var geomAngles: [CrystalGeomAngle_t] = []
    func readAngles( _ crystalData: CIFData ) {
        geomAngles = readCrystalItems( crystalData, CrystalGeomAngle_t.CIFTag.All, mainTag: nil )
    }

    var geomBonds : [CrystalGeomBond_t] = []
    func readBonds( _ crystalData: CIFData ) {
        geomBonds = readCrystalItems( crystalData, CrystalGeomBond_t.CIFTag.All, mainTag: nil )
    }

    var geomContacts: [CrystalGeomContact_t] = []
    func readContacts( _ crystalData: CIFData ) {
        geomContacts = readCrystalItems( crystalData, CrystalGeomContact_t.CIFTag.All, mainTag: nil )
    }

    var geomHydrogenBonds : [CrystalGeomHBond_t] = []
    func readHBonds( _ crystalData: CIFData ) {
        geomHydrogenBonds = readCrystalItems( crystalData, CrystalGeomHBond_t.CIFTag.All, mainTag: nil )
    }

    var geomTorsions: [CrystalGeomTorsion_t] = []
    func readTorsions( _ crystalData: CIFData ) {
        geomTorsions = readCrystalItems( crystalData, CrystalGeomTorsion_t.CIFTag.All, mainTag: nil )
    }

    func generateAtomTypes() {
        types = nub( types + nub( sites.map{ CrystalAtomType_t(site:$0) } ) )
        _ = types.enumerated().map{ $0.element.index = $0.offset }
        _ = sites.map{
            let atomicSymbol = $0.atomicSymbol
            $0.type = types.filter{ $0.atomicSymbol == atomicSymbol }.first
        }
    }

    var wyckoff: [WyckoffItem] = []
    func prepareWyckoff() {
        let indices = wyckoffIndices().map({ ($0,fromIndex($0.0,$0.1)) }).filter({ isEquiv(symop,$0.1) }).map({ $0.0 })
        assert( indices.count <= 1 )
        if let index = indices.first {
            debugPrint("found wyckoff!!")
            wyckoff = generateWyckoffData( index.0, index.1 )
        }

        func checkWyckoff( _ fract: Vector3 ) -> WyckoffItem? {
            for item in wyckoff.sorted( by: { $0.letter.rawValue < $1.letter.rawValue } ) {
                if item.isTorelant( fract ) {
                    return item
                }
            }
            return nil
        }

        let generalPosition = wyckoff.sorted(by: { $0.letter.rawValue < $1.letter.rawValue }).last

        if wyckoff.count > 0 {
            for site in sites {
                if let item = checkWyckoff( site.fract ) {
                    site.wyckoff = item
                    debugPrint("\(site.label) - \(site.fract) - \(site.wyckoff!.letter) - \(site.wyckoff!.siteSymmetry)")
                } else {
                    site.wyckoff = generalPosition
                    debugPrint("\(site.label) - \(site.fract) - \(site.wyckoff!.letter) - \(site.wyckoff!.siteSymmetry) [generalPosition]")
                }
            }
        }
    }

    func updateCrystalInformation(_ crystalData: CIFData ) {

        readCell(crystalData)
        postProgressKey( .ReadCell, progress: 1.0 )
        readSymop(crystalData)
        postProgressKey( .ReadSymop, progress: 1.0 )
        readSites(crystalData)
        //        prepareWyckoff()
        postProgressKey( .ReadSites, progress: 1.0 )
        readAniso(crystalData)
        postProgressKey( .ReadAniso, progress: 1.0 )
        readAngles(crystalData)
        readBonds(crystalData)
        postProgressKey( .ReadBonds, progress: 1.0 )
        readContacts(crystalData)
        readHBonds(crystalData)
        postProgressKey( .ReadHBonds, progress: 1.0 )
        readTorsions(crystalData)

        generateAtomTypes()
    }

}
