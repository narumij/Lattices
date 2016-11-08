//
//  AtomicRadii.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

enum RadiiType : String {
    case Calculated
    case Covalent
    case Covalent3
    case Ion
    case Van_der_Waals
    case Metallic
    case Unit
    case Ellipsoid
    func radius( _ atomicSymbol: AtomicSymbol ) -> RadiiSizeType {
        return getAtomicRadius( self, atomicSymbol: atomicSymbol ) * 0.01
    }
}

var AltRadii : [ RadiiType : RadiiSizeType ] = [
    .Calculated    : 100,
    .Covalent      :  40,
    .Covalent3     :  40,
    .Ion           : 100,
    .Van_der_Waals : 100,
    .Metallic      : 100,
    .Unit          : 100,
    .Ellipsoid     :  50,
]

func getAtomicRadius( _ type: RadiiType, atomicSymbol: AtomicSymbol ) -> RadiiSizeType {

    let dic = RadiiData[atomicSymbol]
    let r = dic?[type] ?? nil

    if r != nil {
        return r!
    }

    switch type {
    case .Calculated:
        return AltRadii[.Calculated]!
    case .Covalent:
        return getAtomicRadius( .Covalent3, atomicSymbol: atomicSymbol )
    case .Covalent3:
        return AltRadii[.Covalent3]!
    case .Ion:
        return AltRadii[.Ion]!
    case .Van_der_Waals:
        return AltRadii[.Van_der_Waals]!
    case .Unit:
        return AltRadii[.Unit]!
    case .Ellipsoid:
        return AltRadii[.Ellipsoid]! * Float(ProbabilityScaleCoef)
    default:
        break
    }

    return 100
}

var RadiiData : [ AtomicSymbol : [RadiiType:RadiiSizeType] ]
    = [
//        .D  : [ .Ion:   4 ],
        .D  : [ .Calculated: 53,  .Van_der_Waals: 120, .Ion:   4, .Covalent: 38 ],

        .H  : [ .Calculated: 53,  .Van_der_Waals: 120, .Ion:  10, .Covalent: 38 ],
        .He : [ .Calculated: 31,  .Van_der_Waals: 140,            .Covalent: 32 ],

        .Li : [ .Calculated: 167, .Van_der_Waals: 182, .Ion:  90, .Covalent: 134, .Metallic: 152 ],
        .Be : [ .Calculated: 112, .Van_der_Waals: 153, .Ion:  41, .Covalent: 90,  .Metallic: 112 ],
        .B  : [ .Calculated: 87,  .Van_der_Waals: 192, .Ion:  25, .Covalent: 82 ],
        .C  : [ .Calculated: 67,  .Van_der_Waals: 170, .Ion:  29, .Covalent: 77 ],
        .N  : [ .Calculated: 56,  .Van_der_Waals: 155, .Ion:  30, .Covalent: 75 ],
        .O  : [ .Calculated: 48,  .Van_der_Waals: 152, .Ion: 121, .Covalent: 73 ],
        .F  : [ .Calculated: 42,  .Van_der_Waals: 147, .Ion: 119, .Covalent: 71 ],
        .Ne : [ .Calculated: 38,  .Van_der_Waals: 154,            .Covalent: 69 ],

        .Na : [ .Calculated: 190, .Van_der_Waals: 227, .Ion: 116, .Covalent: 154, .Metallic: 186 ],
        .Mg : [ .Calculated: 145, .Van_der_Waals: 173, .Ion:  86, .Covalent: 130, .Metallic: 160 ],
        .Al : [ .Calculated: 118, .Van_der_Waals: 184, .Ion:  53, .Covalent: 118, .Metallic: 143 ],
        .Si : [ .Calculated: 111, .Van_der_Waals: 210, .Ion:  40, .Covalent: 111 ],
        .P  : [ .Calculated: 98,  .Van_der_Waals: 180, .Ion:  31, .Covalent: 106 ],
        .S  : [ .Calculated: 88,  .Van_der_Waals: 180, .Ion:  43, .Covalent: 102 ],
        .Cl : [ .Calculated: 79,  .Van_der_Waals: 175, .Ion: 167, .Covalent: 99  ],
        .Ar : [ .Calculated: 71,  .Van_der_Waals: 188,            .Covalent: 97  ],

        .K  : [ .Calculated: 243, .Van_der_Waals: 275, .Ion: 152, .Covalent: 196, .Metallic: 227 ],
        .Ca : [ .Calculated: 194, .Van_der_Waals: 231, .Ion: 114, .Covalent: 174, .Metallic: 197 ],
        .Sc : [ .Calculated: 184, .Van_der_Waals: 211, .Ion:  89, .Covalent: 144, .Metallic: 162 ],
        .Ti : [ .Calculated: 176,                      .Ion:  75, .Covalent: 136, .Metallic: 147 ],
        .V  : [ .Calculated: 171,                      .Ion:  68, .Covalent: 125, .Metallic: 134 ],
        .Cr : [ .Calculated: 166,                      .Ion:  76, .Covalent: 127, .Metallic: 128 ],
        .Mn : [ .Calculated: 161,                      .Ion:  81, .Covalent: 139, .Metallic: 127 ],
        .Fe : [ .Calculated: 156,                      .Ion:  69, .Covalent: 125, .Metallic: 126 ],
        .Co : [ .Calculated: 152,                      .Ion:  54, .Covalent: 126, .Metallic: 125 ],
        .Ni : [ .Calculated: 149, .Van_der_Waals: 163, .Ion:  70, .Covalent: 121, .Metallic: 124 ],
        .Cu : [ .Calculated: 145, .Van_der_Waals: 140, .Ion:  71, .Covalent: 138, .Metallic: 128 ],
        .Zn : [ .Calculated: 142, .Van_der_Waals: 139, .Ion:  74, .Covalent: 131, .Metallic: 134 ],
        .Ga : [ .Calculated: 136, .Van_der_Waals: 187, .Ion:  76, .Covalent: 126, .Metallic: 135 ],
        .Ge : [ .Calculated: 125, .Van_der_Waals: 211, .Ion:  53, .Covalent: 122 ],
        .As : [ .Calculated: 114, .Van_der_Waals: 185, .Ion:  72, .Covalent: 119 ],
        .Se : [ .Calculated: 103, .Van_der_Waals: 190, .Ion:  56, .Covalent: 116 ],
        .Br : [ .Calculated: 94,  .Van_der_Waals: 185, .Ion: 182, .Covalent: 114 ],
        .Kr : [ .Calculated: 88,  .Van_der_Waals: 202,            .Covalent: 110 ],

        .Rb : [ .Calculated: 265, .Van_der_Waals: 303, .Ion: 166, .Covalent: 211, .Metallic: 248 ],
        .Sr : [ .Calculated: 219, .Van_der_Waals: 249, .Ion: 132, .Covalent: 192, .Metallic: 215 ],
        .Y  : [ .Calculated: 212,                      .Ion: 104, .Covalent: 162, .Metallic: 180 ],
        .Zr : [ .Calculated: 206,                      .Ion:  86, .Covalent: 148, .Metallic: 160 ],
        .Nb : [ .Calculated: 198,                      .Ion:  78, .Covalent: 137, .Metallic: 146 ],
        .Mo : [ .Calculated: 190,                      .Ion:  79, .Covalent: 145, .Metallic: 139 ],
        .Tc : [ .Calculated: 183,                      .Ion:  79, .Covalent: 156, .Metallic: 136 ],
        .Ru : [ .Calculated: 178,                      .Ion:  82, .Covalent: 126, .Metallic: 134 ],
        .Rh : [ .Calculated: 173,                      .Ion:  81, .Covalent: 135, .Metallic: 134 ],
        .Pd : [ .Calculated: 169, .Van_der_Waals: 163, .Ion:  78, .Covalent: 131, .Metallic: 137 ],
        .Ag : [ .Calculated: 165, .Van_der_Waals: 172, .Ion: 129, .Covalent: 153, .Metallic: 144 ],
        .Cd : [ .Calculated: 161, .Van_der_Waals: 158, .Ion:  92, .Covalent: 148, .Metallic: 151 ],
        .In : [ .Calculated: 156, .Van_der_Waals: 193, .Ion:  94, .Covalent: 144, .Metallic: 167 ],
        .Sn : [ .Calculated: 145, .Van_der_Waals: 217, .Ion:  69, .Covalent: 141 ],
        .Sb : [ .Calculated: 133, .Van_der_Waals: 206, .Ion:  90, .Covalent: 138 ],
        .Te : [ .Calculated: 123, .Van_der_Waals: 206, .Ion: 111, .Covalent: 135 ],
        .I  : [ .Calculated: 115, .Van_der_Waals: 198, .Ion: 206, .Covalent: 133 ],
        .Xe : [ .Calculated: 108, .Van_der_Waals: 216, .Ion:  62, .Covalent: 130 ],

        .Cs : [ .Calculated: 298, .Van_der_Waals: 343, .Ion: 181, .Covalent: 149, .Metallic: 265 ],
        .Ba : [ .Calculated: 253, .Van_der_Waals: 268, .Ion: 149, .Covalent: 139, .Metallic: 222 ],
        .La : [                                        .Ion: 136, .Covalent: 169, .Metallic: 187 ],
        .Ce : [                                        .Ion: 115,                 .Metallic: 181.8 ],
        .Pr : [ .Calculated: 247,                      .Ion: 132,                 .Metallic: 182.4 ],
        .Nd : [ .Calculated: 206,                      .Ion: 130,                 .Metallic: 181.4 ],
        .Pm : [ .Calculated: 205,                      .Ion: 128,                 .Metallic: 183.4 ],
        .Sm : [ .Calculated: 238,                      .Ion: 110,                 .Metallic: 180.4 ],
        .Eu : [ .Calculated: 231,                      .Ion: 131,                 .Metallic: 180.4 ],
        .Gd : [ .Calculated: 233,                      .Ion: 108, .Covalent3:132, .Metallic: 180.4 ],
        .Tb : [ .Calculated: 225,                      .Ion: 118,                 .Metallic: 177.3 ],
        .Dy : [ .Calculated: 228,                      .Ion: 105,                 .Metallic: 178.1 ],
        .Ho : [                                        .Ion: 104,                 .Metallic: 176.2 ],
        .Er : [ .Calculated: 226,                      .Ion: 103,                 .Metallic: 176.1 ],
        .Tm : [ .Calculated: 222,                      .Ion: 102,                 .Metallic: 175.9 ],
        .Yb : [ .Calculated: 222,                      .Ion: 113,                 .Metallic: 176 ],
        .Lu : [ .Calculated: 217,                      .Ion: 100, .Covalent: 160, .Metallic: 173.8 ],
        .Hf : [ .Calculated: 208,                      .Ion:  85, .Covalent: 150, .Metallic: 159 ],
        .Ta : [ .Calculated: 200,                      .Ion:  78, .Covalent: 138, .Metallic: 146 ],
        .W  : [ .Calculated: 193,                      .Ion:  74, .Covalent: 146, .Metallic: 139 ],
        .Re : [ .Calculated: 188,                      .Ion:  77, .Covalent: 159, .Metallic: 137 ],
        .Os : [ .Calculated: 185,                      .Ion:  77, .Covalent: 128, .Metallic: 135 ],
        .Ir : [ .Calculated: 180,                      .Ion:  77, .Covalent: 137, .Metallic: 135.5 ],
        .Pt : [ .Calculated: 177, .Van_der_Waals: 175, .Ion:  74, .Covalent: 128, .Metallic: 138.5 ],
        .Au : [ .Calculated: 174, .Van_der_Waals: 166, .Ion: 151, .Covalent: 144, .Metallic: 144 ],
        .Hg : [ .Calculated: 171, .Van_der_Waals: 155, .Ion:  83, .Covalent: 149, .Metallic: 151 ],
        .Tl : [ .Calculated: 156, .Van_der_Waals: 196, .Ion: 103, .Covalent: 148, .Metallic: 170 ],
        .Pb : [ .Calculated: 154, .Van_der_Waals: 202, .Ion: 149, .Covalent: 147 ],
        .Bi : [ .Calculated: 143, .Van_der_Waals: 207, .Ion: 117, .Covalent: 146 ],
        .Po : [ .Calculated: 135, .Van_der_Waals: 197, .Ion: 108, .Covalent3:129 ],
        .At : [                   .Van_der_Waals: 202, .Ion:  76, .Covalent3:138 ],
        .Rn : [ .Calculated: 120, .Van_der_Waals: 220,            .Covalent: 145 ],
        
        .Fr : [                   .Van_der_Waals: 348, .Ion: 194 ],
        .Ra : [                   .Van_der_Waals: 283, .Ion: 162, .Covalent3:159 ],
        .Ac : [                                        .Ion: 126, .Covalent3:140 ],
        .Th : [                                        .Ion: 119, .Covalent3:136, .Metallic: 179 ],
        .Pa : [                                        .Ion: 109, .Covalent3:129, .Metallic: 163 ],
        .U  : [                   .Van_der_Waals: 186, .Ion:  87, .Covalent3:118, .Metallic: 156 ],
        .Np : [                                                   .Covalent3:116, .Metallic: 155 ],
        .Pu : [                                        .Ion: 100,                 .Metallic: 159 ],
        .Am : [                                        .Ion: 112,                 .Metallic: 173 ],
        .Cm : [                                        .Ion: 112,                 .Metallic: 174 ],
        .Bk : [                                                                   .Metallic: 170 ],
        .Cf : [                                                                   .Metallic: 186 ],
        .Es : [                                                                   .Metallic: 186 ],
        .Fm : [:],
        .Md : [:],
        .No : [:],
        .Lr : [:],
        .Rf : [:],
        .Db : [:],
        .Sg : [:],
        .Bh : [:],
        .Hs : [:],
        .Mt : [:],
        .Ds : [:],
        .Rg : [:],
        .Cn : [:],
//        .OH : [ .Ion: 118 ]
]


