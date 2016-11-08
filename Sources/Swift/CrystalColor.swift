//
//  CrystalColor.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class CrystalColor {
    var colorScheme : [AtomicSymbol:Vector3] = [:]
    init( _ symbols: [AtomicSymbol] ) {
        colorScheme = atomicColorScheme( symbols )
    }
    func color( _ atomicSymbol: AtomicSymbol ) -> Color {
        return Color( rgb: Vector3( colorVector( atomicSymbol ) ), alpha: 1.0 )
    }

    func colorVector( _ atomicSymbol: AtomicSymbol ) -> SCNVector3 {
        #if false
            return SCNVector3( getAtomicColorVector3( atomicSymbol ) )
        #else
            if let color = colorScheme[atomicSymbol] {
                return SCNVector3( color )
            }
            return SCNVector3(0,0,0)
        #endif
    }

    func specularColor( _ atomicSymbol: AtomicSymbol ) -> Color {
        return Color( rgb: specularVector(atomicSymbol), alpha: 1.0 )
    }

    func specularVector( _ atomicSymbol: AtomicSymbol ) -> Vector3 {

        switch atomicSymbol {
        case .D,.H:
            return vector3(0.1)
        default:
            break
        }

        switch atomicSymbol.toAtomicProperty() {
        case .alkaliMetal,.transitionMetal,.basicMetal,.semimetal,.lanthanide,.actinide:
            return vector3(1)
        case .alkalineEarth:
            return vector3(0.5)
        default:
            return vector3(0.2)
        }

    }

    func shininess( _ atomicSymbol: AtomicSymbol ) -> CGFloat {
        switch atomicSymbol.toAtomicProperty() {
        case .alkaliMetal,.transitionMetal,.basicMetal,.semimetal,.lanthanide,.actinide:
            return 2.8
        case .alkalineEarth:
            return 1.5
        default:
            return 0.8
        }
    }

    func bondColorVector( _ atom: ConcreteAtom_t ) -> SCNVector4 {
        var c = Vector3(colorVector( atom.atomicSymbol ))
        c = c * 0.8 + vector3(0.1)
        return SCNVector4( SCNVector3(c), 1.0 )
    }
}


