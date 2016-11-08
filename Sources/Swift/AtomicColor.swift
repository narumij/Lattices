//
//  AtomicVector3.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/18.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

func getAtomicColorVector3( _ atomicSymbol : AtomicSymbol ) -> Vector3 {
    return RadiiColor[atomicSymbol] ?? UndefinedRadiiColor
}

//func getAtomicColor( atomicSymbol: AtomicSymbol ) -> Color {
//    return Color( rgb: getAtomicColorVector3( atomicSymbol ), alpha: 1.0 )
//}

let Halogens = Vector3( hex: "88AA33" )
let metals = Vector3( hex: "888888" )

#if true
var RadiiColor : [ AtomicSymbol : Vector3 ] = [
    .D  : Vector3( fixedPoint8: 229, 230, 231 ),
    .H  : Vector3( fixedPoint8: 229, 230, 231 ),
    .He : Vector3( fixedPoint8: 102, 77, 75 ),
    .Li : Vector3( fixedPoint8: 203, 33, 40 ),
    .Be : Vector3( fixedPoint8: 218, 128, 45 ),
    .B  : Vector3( fixedPoint8: 0, 171, 235 ),
    .C  : Vector3( fixedPoint8: 165, 167, 169 ),
    .N  : Vector3( fixedPoint8: 108, 109, 112 ),
    .O  : Vector3( fixedPoint8: 38, 36, 36 ),
    .F  : Vector3( fixedPoint8: 125, 42, 138 ),
    .Ne : Vector3( fixedPoint8: 109, 82, 80 ),
    .Na : Vector3( fixedPoint8: 206, 66, 51 ),
    .Mg : Vector3( fixedPoint8: 221, 137, 60 ),
    .Al : Vector3( fixedPoint8: 176, 204, 73 ),
    .Si : Vector3( fixedPoint8: 45, 157, 219 ),
    .P  : Vector3( fixedPoint8: 136, 137, 140 ),
    .S  : Vector3( fixedPoint8: 66, 65, 67 ),
    .Cl : Vector3( fixedPoint8: 133, 64, 146 ),
    .Ar : Vector3( fixedPoint8: 117, 88, 85 ),
    .K  : Vector3( fixedPoint8: 210, 91, 67 ),
    .Ca : Vector3( fixedPoint8: 226, 155, 80 ),
    .Sc : Vector3( fixedPoint8: 248, 220, 47 ),
    .Ti : Vector3( fixedPoint8: 235, 208, 46 ),
    .V  : Vector3( fixedPoint8: 224, 199, 45 ),
    .Cr : Vector3( fixedPoint8: 214, 190, 44 ),
    .Mn : Vector3( fixedPoint8: 203, 181, 42 ),
    .Fe : Vector3( fixedPoint8: 192, 172, 40 ),
    .Co : Vector3( fixedPoint8: 182, 163, 38 ),
    .Ni : Vector3( fixedPoint8: 171, 154, 35 ),
    .Cu : Vector3( fixedPoint8: 161, 145, 32 ),
    .Zn : Vector3( fixedPoint8: 151, 136, 29 ),
    .Ga : Vector3( fixedPoint8: 185, 209, 86 ),
    .Ge : Vector3( fixedPoint8: 77, 162, 220 ),
    .As : Vector3( fixedPoint8: 78, 143, 204 ),
    .Se : Vector3( fixedPoint8: 88, 89, 91 ),
    .Br : Vector3( fixedPoint8: 142, 84, 156 ),
    .Kr : Vector3( fixedPoint8: 124, 94, 91 ),
    .Rb : Vector3( fixedPoint8: 214, 111, 84 ),
    .Sr : Vector3( fixedPoint8: 228, 165, 99 ),
    .Y  : Vector3( fixedPoint8: 248, 221, 92 ),
    .Zr : Vector3( fixedPoint8: 235, 210, 88 ),
    .Nb : Vector3( fixedPoint8: 224, 201, 85 ),
    .Mo : Vector3( fixedPoint8: 214, 192, 81 ),
    .Tc : Vector3( fixedPoint8: 203, 182, 78 ),
    .Ru : Vector3( fixedPoint8: 192, 173, 74 ),
    .Rh : Vector3( fixedPoint8: 182, 164, 70 ),
    .Pd : Vector3( fixedPoint8: 171, 155, 66 ),
    .Ag : Vector3( fixedPoint8: 161, 146, 62 ),
    .Cd : Vector3( fixedPoint8: 151, 137, 58 ),
    .In : Vector3( fixedPoint8: 195, 214, 103 ),
    .Sn : Vector3( fixedPoint8: 143, 178, 70 ),
    .Sb : Vector3( fixedPoint8: 99, 147, 205 ),
    .Te : Vector3( fixedPoint8: 99, 127, 89 ),
    .I  : Vector3( fixedPoint8: 152, 103, 166 ),
    .Xe : Vector3( fixedPoint8: 131, 107, 97 ),
    .Cs : Vector3( fixedPoint8: 218, 130, 103 ),
    .Ba : Vector3( fixedPoint8: 231, 175, 117 ),
    .La : Vector3( fixedPoint8: 100, 168, 163 ),
    .Ce : Vector3( fixedPoint8: 95, 160, 155 ),
    .Pr : Vector3( fixedPoint8: 91, 154, 149 ),
    .Nd : Vector3( fixedPoint8: 87, 147, 143 ),
    .Pm : Vector3( fixedPoint8: 83, 141, 137 ),
    .Sm : Vector3( fixedPoint8: 79, 134, 130 ),
    .Eu : Vector3( fixedPoint8: 75, 128, 125 ),
    .Gd : Vector3( fixedPoint8: 70, 122, 118 ),
    .Tb : Vector3( fixedPoint8: 66, 115, 112 ),
    .Dy : Vector3( fixedPoint8: 61, 108, 105 ),
    .Ho : Vector3( fixedPoint8: 57, 102, 99 ),
    .Er : Vector3( fixedPoint8: 52, 95, 93 ),
    .Tm : Vector3( fixedPoint8: 48, 89, 86 ),
    .Yb : Vector3( fixedPoint8: 43, 82, 80 ),
    .Lu : Vector3( fixedPoint8: 37, 75, 73 ),
    .Hf : Vector3( fixedPoint8: 235, 212, 126 ),
    .Ta : Vector3( fixedPoint8: 224, 203, 121 ),
    .W  : Vector3( fixedPoint8: 214, 194, 116 ),
    .Re : Vector3( fixedPoint8: 203, 184, 111 ),
    .Os : Vector3( fixedPoint8: 192, 175, 106 ),
    .Ir : Vector3( fixedPoint8: 182, 166, 101 ),
    .Pt : Vector3( fixedPoint8: 172, 157, 95 ),
    .Au : Vector3( fixedPoint8: 161, 147, 89 ),
    .Hg : Vector3( fixedPoint8: 151, 138, 84 ),
    .Tl : Vector3( fixedPoint8: 203, 219, 122 ),
    .Pb : Vector3( fixedPoint8: 159, 187, 96 ),
    .Bi : Vector3( fixedPoint8: 116, 157, 66 ),
    .Po : Vector3( fixedPoint8: 117, 130, 189 ),
    .At : Vector3( fixedPoint8: 163, 121, 176 ),
    .Rn : Vector3( fixedPoint8: 255, 255, 255 ),
    .Fr : Vector3( fixedPoint8: 255, 255, 255 ),
    .Ra : Vector3( fixedPoint8: 255, 255, 255 ),
    .Ac : Vector3( fixedPoint8: 255, 255, 255 ),
    .Th : Vector3( fixedPoint8: 255, 255, 255 ),
    .Pa : Vector3( fixedPoint8: 255, 255, 255 ),
    .U  : Vector3( fixedPoint8: 255, 255, 255 ),
    .Np : Vector3( fixedPoint8: 255, 255, 255 ),
    .Pu : Vector3( fixedPoint8: 255, 255, 255 ),
    .Am : Vector3( fixedPoint8: 255, 255, 255 ),
    .Cm : Vector3( fixedPoint8: 255, 255, 255 ),
    .Bk : Vector3( fixedPoint8: 255, 255, 255 ),
    .Cf : Vector3( fixedPoint8: 255, 255, 255 ),
    .Es : Vector3( fixedPoint8: 255, 255, 255 ),
    .Fm : Vector3( fixedPoint8: 255, 255, 255 ),
    .Md : Vector3( fixedPoint8: 255, 255, 255 ),
    .No : Vector3( fixedPoint8: 255, 255, 255 )
]

#else
var RadiiColor : [ AtomicSymbol : Vector3 ] = [
    .D  : Vector3( webcolor: "DDDDDD" ),
    .H  : Vector3( webcolor: "DDDDDD" ),
    .He : Vector3( 1.00000, 0.78430, 0.78430 ),
    .Li : Vector3( 0.64709, 0.16469, 0.16469 ),
    .Be : UndefinedRadiiColor,
    .B  : Vector3( 0.00000, 1.00000, 0.00000 ),
    .C  : Vector3( webcolor: "444444" ),
    .N  : Vector3( webcolor: "5577BB" ),
    .O  : Vector3( webcolor: "BB3333" ),
    .F : Halogens,
    .Ne : UndefinedRadiiColor,
    .Na : Vector3( 0.00000, 0.00000, 1.00000 ),
    .Mg : Vector3( 0.16469, 0.50199, 0.16469 ),
    .Al : Vector3( 0.50199, 0.50199, 0.56469 ),
    .Si : Vector3( 0.78430, 0.64709, 0.09409 ),
    .P  : Vector3( webcolor: "883366" ),
    .S  : Vector3( webcolor: "DDBB33" ),
    .Cl : Halogens,
    .Ar : UndefinedRadiiColor,
    .K  : UndefinedRadiiColor,
    .Ca : Vector3( 0.50199, 0.50199, 0.56469 ),
    .Sc : UndefinedRadiiColor,
    .Ti : Vector3( 0.50199, 0.50199, 0.56469 ),
    .V  : UndefinedRadiiColor,
    .Cr : Vector3( 0.50199, 0.50199, 0.56469 ),
    .Mn : Vector3( 0.50199, 0.50199, 0.56469 ),
    .Fe : Vector3( 1.00000, 0.64709, 0.00000 ),
    .Co : UndefinedRadiiColor,
    .Ni : Vector3( 0.64709, 0.16469, 0.16469 ),
    .Cu : Vector3( 0.64709, 0.16469, 0.16469 ),
    .Zn : Vector3( 0.64709, 0.16469, 0.16469 ),
    .Ga : UndefinedRadiiColor,
    .Ge : UndefinedRadiiColor,
    .As : UndefinedRadiiColor,
    .Se : UndefinedRadiiColor,
    .Br : Halogens,
    .Kr : UndefinedRadiiColor,
    .Rb : UndefinedRadiiColor,
    .Sr : UndefinedRadiiColor,
    .Y  : UndefinedRadiiColor,
    .Zr : UndefinedRadiiColor,
    .Nb : UndefinedRadiiColor,
    .Mo : UndefinedRadiiColor,
    .Tc : UndefinedRadiiColor,
    .Ru : UndefinedRadiiColor,
    .Rh : UndefinedRadiiColor,
    .Pd : UndefinedRadiiColor,
    .Ag : Vector3( 0.50199, 0.50199, 0.56469 ),
    .Cd : UndefinedRadiiColor,
    .In : UndefinedRadiiColor,
    .Sn : UndefinedRadiiColor,
    .Sb : UndefinedRadiiColor,
    .Te : UndefinedRadiiColor,
    .I : Halogens,
    .Xe : UndefinedRadiiColor,
    .Cs : UndefinedRadiiColor,
    .Ba : Vector3( 1.00000, 0.64709, 0.00000 ),
    .La : UndefinedRadiiColor,
    .Ce : UndefinedRadiiColor,
    .Pr : UndefinedRadiiColor,
    .Nd : UndefinedRadiiColor,
    .Pm : UndefinedRadiiColor,
    .Sm : UndefinedRadiiColor,
    .Eu : UndefinedRadiiColor,
    .Gd : UndefinedRadiiColor,
    .Tb : UndefinedRadiiColor,
    .Dy : UndefinedRadiiColor,
    .Ho : UndefinedRadiiColor,
    .Er : UndefinedRadiiColor,
    .Tm : UndefinedRadiiColor,
    .Yb : UndefinedRadiiColor,
    .Lu : UndefinedRadiiColor,
    .Hf : UndefinedRadiiColor,
    .Ta : UndefinedRadiiColor,
    .W  : UndefinedRadiiColor,
    .Re : UndefinedRadiiColor,
    .Os : UndefinedRadiiColor,
    .Ir : UndefinedRadiiColor,
    .Pt : UndefinedRadiiColor,
    .Au : Vector3( 0.78430, 0.64709, 0.09409 ),
    .Hg : UndefinedRadiiColor,
    .Tl : UndefinedRadiiColor,
    .Pb : UndefinedRadiiColor,
    .Bi : UndefinedRadiiColor,
    .Po : UndefinedRadiiColor,
    .At : UndefinedRadiiColor,
    .Rn : UndefinedRadiiColor,
    .Fr : UndefinedRadiiColor,
    .Ra : UndefinedRadiiColor,
    .Ac : UndefinedRadiiColor,
    .Th : UndefinedRadiiColor,
    .Pa : UndefinedRadiiColor,
    .U  : UndefinedRadiiColor,
    .Np : UndefinedRadiiColor,
    .Pu : UndefinedRadiiColor,
    .Am : UndefinedRadiiColor,
    .Cm : UndefinedRadiiColor,
    .Bk : UndefinedRadiiColor,
    .Cf : UndefinedRadiiColor,
    .Es : UndefinedRadiiColor,
    .Fm : UndefinedRadiiColor,
    .Md : UndefinedRadiiColor,
    .No : UndefinedRadiiColor
]
#endif

let UndefinedRadiiColor = Vector3( 1.00000, 0.07839, 0.57649 )


















