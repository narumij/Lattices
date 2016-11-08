//
//  AtomicColorScheme.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/31.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

private let AtomColor1 = Vector3( hex: "DDDDDD" )
private let AtomColor2 = Vector3( hex: "777777" )
private let AtomColor3 = Vector3( hex: "2277CC" )
private let AtomColor4 = Vector3( hex: "BB3333" )
private let AtomColor5 = Vector3( hex: "DDBB33" )
private let AtomColor6 = Vector3( hex: "883399" )
private let AtomColor7 = Vector3( hex: "33AA44" )
private let AtomColor8 = Vector3( hex: "DB5588" )
private let AtomColor9 = Vector3( hex: "906611" )
private let AtomColor10 = Vector3( hex: "00B0CC" )
private let AtomColor11 = Vector3( hex: "DD8822" )
private let AtomColor12 = Vector3( hex: "BBDD22" )

//private let AtomColor
private let white = AtomColor1
private let darkGray = AtomColor2

private let yellow = AtomColor5
private let yellowGreen = AtomColor12
private let green = AtomColor7
private let blueGreen = AtomColor10
private let blue = AtomColor3
private let purple = AtomColor6
private let pink = AtomColor8
private let red = AtomColor4
private let orange = AtomColor11
private let brown = AtomColor9

private let colorRingArray = [yellow,yellowGreen,green,blueGreen,blue,purple,pink,red,orange,brown]

func colorRing( _ start: Vector3, reverse: Bool ) -> [Vector3] {
    assert(colorRingArray.contains(start))
    var colors = reverse ? colorRingArray.reversed() : colorRingArray
    while colors.first != start {
        colors.append(colors.first!)
        colors.removeFirst()
    }
    return colors
}

func atomicColorScheme( _ symbols: [AtomicSymbol] ) -> [AtomicSymbol:Vector3] {

    var symbols = symbols

//    #if true
//        var rest = colorRingArray + [white,darkGray]
//    #else
    var rest = [AtomColor6,
                AtomColor7,
                AtomColor8,
                AtomColor9,
                AtomColor10,
                AtomColor11,
                AtomColor12,
                AtomColor1,
                AtomColor2,
                AtomColor3,
                AtomColor4,
                AtomColor5]
//    #endif

    var scheme : [AtomicSymbol:Vector3] = [:]

    let cpkColors : [AtomicSymbol:Vector3] = [
        .H : white, .C : darkGray, .N : blue, .O : red, .S : yellow, .P : pink
    ]

    for cpk in cpkColors.keys {
        if symbols.contains(cpk) {
            scheme[cpk] = cpkColors[cpk]
            if let index = rest.index(of: cpkColors[cpk]!) {
                rest.remove(at: index)
            }
        }
    }
    symbols = symbols.filter({ !cpkColors.keys.contains($0) })

    let priorityColors : [AtomicProperty:Vector3] = [
        .alkaliMetal:red,
        .alkalineEarth:orange,
        .transitionMetal:yellow,
        .basicMetal:yellowGreen,
        .semimetal:blue,
        .halogen:AtomColor6,
        .nobleGas:AtomColor9,
        .lanthanide:AtomColor7,
        .actinide:AtomColor8 ]

    #if true
        let colorCandidates : [AtomicProperty:[Vector3]] = [
            .alkaliMetal:[pink,red,purple,orange,brown],
            .alkalineEarth:[orange,brown,red,yellow,pink],
            .transitionMetal:[yellow,green,purple,brown,yellowGreen],
            .basicMetal:[yellowGreen,green,blueGreen],
            .semimetal:[blueGreen,blue,green,yellowGreen],
            .halogen:[purple,pink,red,blueGreen],
            .nobleGas:[brown,red,orange],
            .lanthanide:[green],
            .actinide:[pink],
            ]
    #else
        let colorCandidates : [AtomicProperty:[Vector3]] = [
            .AlkaliMetal:[red],
            .AlkalineEarth:[orange],
            .TransitionMetal:[yellow],
            .BasicMetal:[yellowGreen],
            .Semimetal:[blue],
            .Halogen:[purple],
            .NobleGas:[brown],
            .Lanthanide:[blueGreen],
            .Actinide:[pink],
            ]
    #endif

    func candidate( _ property: AtomicProperty ) -> Vector3? {
        if let colors = colorCandidates[property] {
            assert(colors.count == nub(colors).count)
            for color in colors {
                if rest.contains(color) {
                    return color
                }
            }
        }
        return nil
    }

    for symbol in symbols {
        if !priorityColors.keys.contains(symbol.toAtomicProperty()) {
            continue
        }
//        let color = priorityColors[symbol.toAtomicProperty()]!
        if let color = candidate(symbol.toAtomicProperty()) {
//            if rest.contains(color) {
                scheme[symbol] = color
                rest = rest.filter({ $0 != color })
                symbols = symbols.filter({$0 != symbol})
//            }
        }
    }

    for (i,symbol) in symbols.enumerated() {
        if let first = rest.first {
            scheme[symbol] = first
            rest.removeFirst()
        }
        else {
            scheme[symbol] = i % 2 == 0 ? Vector3(hex:"FFFFFF") : Vector3(hex:"000000")
        }
    }

    return scheme
}









