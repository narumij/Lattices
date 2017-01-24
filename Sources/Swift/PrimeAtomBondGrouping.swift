//
//  PrimeAtomGrouping.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/01.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import simd

extension PrimeCrystal_t {

    func generatePrimeAtomBondGroups( _ primeAtoms: [PrimeAtom_t] ) -> [PrimeAtomBondGroup_t] {

//        var groupIndex : Int = 0
        var wholeRest = primeAtoms

        var groupAtoms : [PrimeAtom_t] = []
        var nextAtoms : [PrimeAtom_t] = []
        var current : PrimeAtom_t? = nil

        func begin() {
            current = wholeRest.popLast()
            groupAtoms.append(current!)
            pushNext()
        }

        func next() {
            current = nextAtoms.popLast()
            pushNext()
        }

        func pushNext() {
            var atoms : [PrimeAtom_t] = current?.primeBonds.filter({ $0.leftLatticeCoord == nil }).map({ [$0.left!,$0.right!] }).joined().map{ $0 } ?? []
            atoms = nub( atoms )
            atoms = atoms.reduce([]){ !groupAtoms.contains( $1 ) ? $0 + [$1] : $0 }
            nextAtoms = nub( nextAtoms + atoms )
            groupAtoms = nub( groupAtoms + atoms )
            wholeRest = wholeRest.filter{ !atoms.contains($0) }
        }

        func end() {
            groupAtoms = []
            nextAtoms = []
            current = nil
        }

        var groups : [[PrimeAtom_t]] = []

        var ended : Int = 0

        while wholeRest.count > 0 {

            begin()

            while nextAtoms.count > 0 {
                next()
            }

//            let group = PrimeAtomBondGroup_t( index: groupIndex, atoms: groupAtoms )
            groups.append(groupAtoms)
            ended += groupAtoms.count
            //        debugPrint( "group -> [\(groupIndex)] : atom-\(groupAtoms.count), rest-\(wholeRest.count), bonds-\(groupAtoms.map({$0.primeBonds.count}).reduce(0){$0+$1})" )

            end()
//            groupIndex += 1
            assert( ended + wholeRest.count == primeAtoms.count )
        }

        func sortPredicate(l:[PrimeAtom_t],r:[PrimeAtom_t]) -> Bool {
            if l.count != r.count {
                return l.count > r.count
            }
            let leftRepresented = l.sorted(by: { $0.site.index < $1.site.index }).first!
            let rightRepresented = r.sorted(by: { $0.site.index < $1.site.index }).first!
            if leftRepresented.site.index != rightRepresented.site.index {
                return leftRepresented.site.index < rightRepresented.site.index
            }
            return leftRepresented.symop.index < rightRepresented.symop.index
        }

        return groups.sorted( by: sortPredicate ).enumerated().map{ PrimeAtomBondGroup_t(index: $0.offset, atoms: $0.element ) }
    }

}

extension PrimeAtomBondGroup_t {

    func preparePositions() {

        var rest : [PrimeAtom_t] = atoms

        func removeRestWith( _ objects: [PrimeAtomAndCoord] ) {
            let atoms : [PrimeAtom_t] = atomsFrom( objects )
            rest = rest.filter{ !atoms.contains($0) }
        }

        func filterdArray( _ objects: [PrimeAtomAndCoord] ) -> [PrimeAtomAndCoord] {
            return objects.filter({ rest.contains( $0.atom! ) })
        }

        func oppositionsFrom( _ atom: PrimeAtom_t?, currentCoord: LatticeCoord ) -> [PrimeAtomAndCoord] {
            return filterdArray( atom?.oppositions ?? [] ).map{( $0.atom, $0.coord + currentCoord )}
        }

        func atomsFrom( _ objects: [PrimeAtomAndCoord] ) -> [PrimeAtom_t] {
            return objects.map({ $0.atom }).reduce([]) {
                if let b = $1 {
                    return $0 + [b]
                }
                return $0
            }
        }

        func atomCountOf( _ d: [LatticeCoord:[PrimeAtom_t]] ) -> Int {
            return d.map({ $0.1.count }).reduce(0) { $0 + $1 }
        }

        var outObjects : [PrimeAtomAndCoord] = []

        func appendOutObject( _ object: PrimeAtomAndCoord ) {
            let outAtoms = atomsFrom( outObjects )
            if !outAtoms.contains(object.atom!) {
                outObjects = outObjects + [object]
            }
        }

        func selectAtoms( _ atom: PrimeAtom_t, coord: LatticeCoord ) {

            if !rest.contains(atom) {
                return
            }

            var result : [PrimeAtom_t] = [atom]
            var current : PrimeAtomAndCoord? = (atom,coord)
            var inObjects : [PrimeAtomAndCoord] = [(atom,coord)]
            removeRestWith( [current!] )

            while current != nil {
                let oppositions : [PrimeAtomAndCoord] = oppositionsFrom( current!.atom, currentCoord: current!.coord )
                for opposition in oppositions {
                    if rest.contains(opposition.atom!) {
                        if opposition.coord == current!.coord {
                            inObjects = inObjects + [opposition]
                            result.append( opposition.atom! )
                            removeRestWith( [opposition] )
                        }
                        else {
                            appendOutObject( opposition )
                        }
                    }
                }
                current = inObjects.count > 0 ? inObjects.popLast() : nil
            }

            positions[coord] = (positions[coord] ?? []) + result
            //            debugPrint("atom.count(\(atoms.count)) == rest.count(\(rest.count)) + atomCountOf(\(atomCountOf(positions)))")
            assert( atoms.count == rest.count + atomCountOf(positions) )
        }

        selectAtoms( rest.first!, coord: LatticeCoordZero )

        while outObjects.count > 0 {
            let object = outObjects.first!
            selectAtoms( object.atom!, coord: object.coord )
            outObjects = filterdArray( outObjects )
        }

        assert( atoms.count == atomCountOf(positions) )

        #if true
            // 中心と重心との距離が近い配置を選択するアルゴリズム
            func hoge(_ coord:LatticeCoord,_ atoms:[PrimeAtom_t]) -> Vector3 {
                return atoms.map({ (atom) in return atom.fract(coord) }).reduce( Vector3Zero, { $0 + $1 } )
            }
            let sumVec = positions.map({ (coord,atoms) in return hoge( coord, atoms ) }).reduce( Vector3Zero, { $0 + $1 } )
            let sumNum = positions.values.map({ $0.count }).reduce(0) { $0 + $1 }
            let center = sumVec / Vector3(sumNum)
            if let cell = atoms.first?.cell {

                func cartn( _ fract: Vector3 ) -> Vector3 {
                    return (cell.matrix4x4 * vector4( fract, 1 ) ).xyz
                }

                func boolean( _ a: (coord:LatticeCoord,d:FloatType), _ b: (coord:LatticeCoord,d:FloatType) ) -> Bool {
                    return ( a.d =~~ b.d && a.coord == LatticeCoordZero ) || a.d < b.d
                }

                let hoge = positions.keys.map({
                    (coord:$0,d:distance(cartn(center-vector_float($0)),cell.cartnCenter))
                }).sorted(by: {
                    (a, b) -> Bool in return boolean(a,b)
                }).first

                if let offset = hoge?.coord {
                    if offset != LatticeCoordZero {
                        let oldPositions = positions
                        positions = [:]
                        for coord in oldPositions.keys {
                            positions[ coord - offset ] = oldPositions[coord]
                        }
                    }
                }
            }
        #else
            // 配置数の多い格子を選択するアルゴリズム
            let maxCount : Int = positions.map({$0.1.count}).reduce(0){ max($0,$1) }
            let topPositions : [LatticeCoord] = positions.filter({$0.1.count == maxCount}).map{$0.0}

            if !topPositions.contains(LatticeCoordZero) {
                let centerOfGravity = topPositions.first!
                let oldPositions = positions
                positions = [:]
                for coord in oldPositions.keys {
                    positions[ coord - centerOfGravity ] = oldPositions[coord]
                }
            }
        #endif
        
        //        debugPrint("atom group result = \(positions.map({ ( $0.0, $0.1.count ) }).sort({ $0.1 > $1.1 || $0.0 == LatticeCoordZero }))")
        assert( atoms.count == atomCountOf(positions) )
        
        _ = positions.map{
            let coord = $0.0
            _ = $0.1.map{
                $0.primeAtomBondGroup = self
                $0.primeAtomBondGroupCoord = coord
            }
        }
    }
}


