//
//  AtomicNumber.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

enum AtomicSymbol : String {
    case unknown = "?"

    case H
    case He

    case Li
    case Be
    case B
    case C
    case N
    case O
    case F
    case Ne

    case Na
    case Mg
    case Al
    case Si
    case P
    case S
    case Cl
    case Ar

    case K
    case Ca
    case Sc
    case Ti
    case V
    case Cr
    case Mn
    case Fe
    case Co
    case Ni
    case Cu
    case Zn
    case Ga
    case Ge
    case As
    case Se
    case Br
    case Kr

    case Rb
    case Sr
    case Y
    case Zr
    case Nb
    case Mo
    case Tc
    case Ru
    case Rh
    case Pd
    case Ag
    case Cd
    case In
    case Sn
    case Sb
    case Te
    case I
    case Xe

    case Cs
    case Ba
    case La
    case Ce
    case Pr
    case Nd
    case Pm
    case Sm
    case Eu
    case Gd
    case Tb
    case Dy
    case Ho
    case Er
    case Tm
    case Yb
    case Lu
    case Hf
    case Ta
    case W
    case Re
    case Os
    case Ir
    case Pt
    case Au
    case Hg
    case Tl
    case Pb
    case Bi
    case Po
    case At
    case Rn

    case Fr
    case Ra
    case Ac
    case Th
    case Pa
    case U
    case Np
    case Pu
    case Am
    case Cm
    case Bk
    case Cf
    case Es
    case Fm
    case Md
    case No
    case Lr
    case Rf
    case Db
    case Sg
    case Bh
    case Hs
    case Mt
    case Ds
    case Rg
    case Cn
    case Nh
    case Fl
    case Mc
    case Lv
    case Ts
    case Og

    case D
}

enum AtomicName : String {

    case unknown = "Unknown"

    case H = "Hydrogen"
    case He = "Helium"

    case Li = "Lithium"
    case Be = "Berylium"
    case B  = "Boron"
    case C  = "Carbon"
    case N  = "Nitrogen"
    case O  = "Oxygen"
    case F  = "Fluorine"
    case Ne = "Neon"

    case Na = "Sodium"
    case Mg = "Magnesium"
    case Al = "Aluminium"
    case Si = "Silicon"
    case P  = "Phosphorus"
    case S  = "Sulfur"
    case Cl = "Chlorine"
    case Ar = "Argon"

    case K  = "Potasium"
    case Ca = "Calcium"
    case Sc = "Scandium"
    case Ti = "Titanium"
    case V  = "Vandadium"
    case Cr = "Chromium"
    case Mn = "Manganese"
    case Fe = "Iron"
    case Co = "Cobalt"
    case Ni = "Nickel"
    case Cu = "Copper"
    case Zn = "Zinc"
    case Ga = "Gallium"
    case Ge = "Germanium"
    case As = "Arsenic"
    case Se = "Selenium"
    case Br = "Bromine"
    case Kr = "Krypton"

    case Rb = "Rubidium"
    case Sr = "Strontium"
    case Y  = "Yttrium"
    case Zr = "Zirconium"
    case Nb = "Niobium"
    case Mo = "Molybdenum"
    case Tc = "Technetium"
    case Ru = "Ruthenium"
    case Rh = "Rhodium"
    case Pd = "Palladium"
    case Ag = "Silver"
    case Cd = "Cadmium"
    case In = "Indium"
    case Sn = "Tin"
    case Sb = "Antimony"
    case Te = "Tellurium"
    case I  = "Iodine"
    case Xe = "Xenon"

    case Cs = "Caesium"
    case Ba = "Barium"
    case La = "Lanthanum"
    case Ce = "Cerium"
    case Pr = "Praseodymium"
    case Nd = "Neodymium"
    case Pm = "Promethium"
    case Sm = "Samarium"
    case Eu = "Europium"
    case Gd = "Gadolinium"
    case Tb = "Terbium"
    case Dy = "Dysprosium"
    case Ho = "Holmium"
    case Er = "Erbium"
    case Tm = "Thulium"
    case Yb = "Ytterbium"
    case Lu = "Lutetium"
    case Hf = "Hafnium"
    case Ta = "Tantalum"
    case W  = "Tungsten"
    case Re = "Rhenium"
    case Os = "Osmium"
    case Ir = "Iridium"
    case Pt = "Platinum"
    case Au = "Gold"
    case Hg = "Mercury"
    case Tl = "Thallium"
    case Pb = "Lead"
    case Bi = "Bismuth"
    case Po = "Polonium"
    case At = "Astatine"
    case Rn = "Radon"

    case Fr = "Francium"
    case Ra = "Radium"
    case Ac = "Actinium"
    case Th = "Thorium"
    case Pa = "Protactium"
    case U  = "Uranium"
    case Np = "Neptunium"
    case Pu = "Plutonium"
    case Am = "Americium"
    case Cm = "Curium"
    case Bk = "Berkelium"
    case Cf = "Californium"
    case Es = "Einsteinium"
    case Fm = "Fermium"
    case Md = "Mendelevium"
    case No = "Nobelium"
    case Lr = "Lawrencium"
    case Rf = "Rutherfordium"
    case Db = "Dubnium"
    case Sg = "Seaborgium"
    case Bh = "Bohrium"
    case Hs = "Hassium"
    case Mt = "Meitnerium"
    case Ds = "Darmstadium"
    case Rg = "Roentgenium"
    case Cn = "Copernicium"
    case Nh = "Nihonium"
    case Fl = "Flerovium"
    case Mc = "Moscovium"
    case Lv = "Livermorium"
    case Ts = "Tennessine"
    case Og = "Oganesson"

    case D = "Deuterium"
}

enum AtomicNumber : Int {

    case unknown = 0;

    case H  = 1
    case He = 2

    case Li = 3
    case Be = 4
    case B  = 5
    case C  = 6
    case N  = 7
    case O  = 8
    case F  = 9
    case Ne = 10

    case Na = 11
    case Mg = 12
    case Al = 13
    case Si = 14
    case P  = 15
    case S  = 16
    case Cl = 17
    case Ar = 18

    case K  = 19
    case Ca = 20
    case Sc = 21
    case Ti = 22
    case V  = 23
    case Cr = 24
    case Mn = 25
    case Fe = 26
    case Co = 27
    case Ni = 28
    case Cu = 29
    case Zn = 30
    case Ga = 31
    case Ge = 32
    case As = 33
    case Se = 34
    case Br = 35
    case Kr = 36

    case Rb = 37
    case Sr = 38
    case Y  = 39
    case Zr = 40
    case Nb = 41
    case Mo = 42
    case Tc = 43
    case Ru = 44
    case Rh = 45
    case Pd = 46
    case Ag = 47
    case Cd = 48
    case In = 49
    case Sn = 50
    case Sb = 51
    case Te = 52
    case I  = 53
    case Xe = 54

    case Cs = 55
    case Ba = 56
    case La = 57
    case Ce = 58
    case Pr = 59
    case Nd = 60
    case Pm = 61
    case Sm = 62
    case Eu = 63
    case Gd = 64
    case Tb = 65
    case Dy = 66
    case Ho = 67
    case Er = 68
    case Tm = 69
    case Yb = 70
    case Lu = 71
    case Hf = 72
    case Ta = 73
    case W  = 74
    case Re = 75
    case Os = 76
    case Ir = 77
    case Pt = 78
    case Au = 79
    case Hg = 80
    case Tl = 81
    case Pb = 82
    case Bi = 83
    case Po = 84
    case At = 85
    case Rn = 86

    case Fr = 87
    case Ra = 88
    case Ac = 89
    case Th = 90
    case Pa = 91
    case U  = 92
    case Np = 93
    case Pu = 94
    case Am = 95
    case Cm = 96
    case Bk = 97
    case Cf = 98
    case Es = 99
    case Fm = 100
    case Md = 101
    case No = 102
    case Lr = 103
    case Rf = 104
    case Db = 105
    case Sg = 106
    case Bh = 107
    case Hs = 108
    case Mt = 109
    case Ds = 110
    case Rg = 111
    case Cn = 112
    case Nh = 113
    case Fl = 114
    case Mc = 115
    case Lv = 116
    case Ts = 117
    case Og = 118

}

enum AtomicProperty {
    case unknown
    case alkaliMetal
    case alkalineEarth
    case transitionMetal
    case basicMetal
    case semimetal
    case nonmetal
    case halogen
    case nobleGas
    case lanthanide
    case actinide
}

let atomicSymbolPattern =
    "^(A[cglmrstu]"
        + "|B[aehikr]?"
        + "|C[adeflmnorsu]?"
        + "|D[bsy]?"
        + "|E[rsu]?"
        + "|F[elmr]?"
        + "|G[ade]"
        + "|H[efgos]?"
        + "|I[nr]?"
        + "|Kr?"
        + "|L[airuv]?"
        + "|M[cdgnot]"
        + "|N[abdehiop]?"
        + "|O[Hgs]?"
        + "|P[abdmortu]?"
        + "|R[abefghnu]"
        + "|S[bcegimnr]?"
        + "|T[abcehilms]"
        + "|U"
        + "|V"
        + "|W"
        + "|Xe"
        + "|Yb?"
        + "|Z[nr])"

extension AtomicSymbol {

    init?( symbol: String ) {
        let rawValue = Regexp(atomicSymbolPattern).matches(symbol).first ?? AtomicSymbol.unknown.rawValue
        self.init( rawValue: rawValue )
    }

    init?( label: String ) {
        let rawValue = Regexp(atomicSymbolPattern).matches(label).first ?? AtomicSymbol.unknown.rawValue
        self.init( rawValue: rawValue )
    }

    init?( symbol: String, label: String ) {
        if symbol.length != 0 {
            self.init( symbol: symbol )
        } else {
            self.init( label: label )
        }
    }

    func toAtomicName() -> AtomicName {
        switch self {
        case  .H: return .H
        case .He: return .He

        case .Li: return .Li
        case .Be: return .Be
        case  .B: return .B
        case  .C: return .C
        case  .N: return .N
        case  .O: return .O
        case  .F: return .F
        case .Ne: return .Ne

        case .Na: return .Na
        case .Mg: return .Mg
        case .Al: return .Al
        case .Si: return .Si
        case  .P: return .P
        case  .S: return .S
        case .Cl: return .Cl
        case .Ar: return .Ar

        case  .K: return .K
        case .Ca: return .Ca
        case .Sc: return .Sc
        case .Ti: return .Ti
        case  .V: return .V
        case .Cr: return .Cr
        case .Mn: return .Mn
        case .Fe: return .Fe
        case .Co: return .Co
        case .Ni: return .Ni
        case .Cu: return .Cu
        case .Zn: return .Zn
        case .Ga: return .Ga
        case .Ge: return .Ge
        case .As: return .As
        case .Se: return .Se
        case .Br: return .Br
        case .Kr: return .Kr

        case .Rb: return .Rb
        case .Sr: return .Sr
        case  .Y: return .Y
        case .Zr: return .Zr
        case .Nb: return .Nb
        case .Mo: return .Mo
        case .Tc: return .Tc
        case .Ru: return .Ru
        case .Rh: return .Rh
        case .Pd: return .Pd
        case .Ag: return .Ag
        case .Cd: return .Cd
        case .In: return .In
        case .Sn: return .Sn
        case .Sb: return .Sb
        case .Te: return .Te
        case  .I: return .I
        case .Xe: return .Xe

        case .Cs: return .Cs
        case .Ba: return .Ba
        case .La: return .La
        case .Ce: return .Ce
        case .Pr: return .Pr
        case .Nd: return .Nd
        case .Pm: return .Pm
        case .Sm: return .Sm
        case .Eu: return .Eu
        case .Gd: return .Gd
        case .Tb: return .Tb
        case .Dy: return .Dy
        case .Ho: return .Ho
        case .Er: return .Er
        case .Tm: return .Tm
        case .Yb: return .Yb
        case .Lu: return .Lu
        case .Hf: return .Hf
        case .Ta: return .Ta
        case  .W: return .W
        case .Re: return .Re
        case .Os: return .Os
        case .Ir: return .Ir
        case .Pt: return .Pt
        case .Au: return .Au
        case .Hg: return .Hg
        case .Tl: return .Tl
        case .Pb: return .Pb
        case .Bi: return .Bi
        case .Po: return .Po
        case .At: return .At
        case .Rn: return .Rn

        case .Fr: return .Fr
        case .Ra: return .Ra
        case .Ac: return .Ac
        case .Th: return .Th
        case .Pa: return .Pa
        case  .U: return .U
        case .Np: return .Np
        case .Pu: return .Pu
        case .Am: return .Am
        case .Cm: return .Cm
        case .Bk: return .Bk
        case .Cf: return .Cf
        case .Es: return .Es
        case .Fm: return .Fm
        case .Md: return .Md
        case .No: return .No
        case .Lr: return .Lr
        case .Rf: return .Rf
        case .Db: return .Db
        case .Sg: return .Sg
        case .Bh: return .Bh
        case .Hs: return .Hs
        case .Mt: return .Mt
        case .Ds: return .Ds
        case .Rg: return .Rg
        case .Cn: return .Cn
        case .Nh: return .Nh
        case .Fl: return .Fl
        case .Mc: return .Mc
        case .Lv: return .Lv
        case .Ts: return .Ts
        case .Og: return .Og

        case .D: return .D

        default: break
        }
        return .unknown
    }

    func toAtomicNumber() -> AtomicNumber {
        switch self {
        case  .H: return .H
        case .He: return .He

        case .Li: return .Li
        case .Be: return .Be
        case  .B: return .B
        case  .C: return .C
        case  .N: return .N
        case  .O: return .O
        case  .F: return .F
        case .Ne: return .Ne

        case .Na: return .Na
        case .Mg: return .Mg
        case .Al: return .Al
        case .Si: return .Si
        case  .P: return .P
        case  .S: return .S
        case .Cl: return .Cl
        case .Ar: return .Ar

        case  .K: return .K
        case .Ca: return .Ca
        case .Sc: return .Sc
        case .Ti: return .Ti
        case  .V: return .V
        case .Cr: return .Cr
        case .Mn: return .Mn
        case .Fe: return .Fe
        case .Co: return .Co
        case .Ni: return .Ni
        case .Cu: return .Cu
        case .Zn: return .Zn
        case .Ga: return .Ga
        case .Ge: return .Ge
        case .As: return .As
        case .Se: return .Se
        case .Br: return .Br
        case .Kr: return .Kr

        case .Rb: return .Rb
        case .Sr: return .Sr
        case  .Y: return .Y
        case .Zr: return .Zr
        case .Nb: return .Nb
        case .Mo: return .Mo
        case .Tc: return .Tc
        case .Ru: return .Ru
        case .Rh: return .Rh
        case .Pd: return .Pd
        case .Ag: return .Ag
        case .Cd: return .Cd
        case .In: return .In
        case .Sn: return .Sn
        case .Sb: return .Sb
        case .Te: return .Te
        case  .I: return .I
        case .Xe: return .Xe

        case .Cs: return .Cs
        case .Ba: return .Ba
        case .La: return .La
        case .Ce: return .Ce
        case .Pr: return .Pr
        case .Nd: return .Nd
        case .Pm: return .Pm
        case .Sm: return .Sm
        case .Eu: return .Eu
        case .Gd: return .Gd
        case .Tb: return .Tb
        case .Dy: return .Dy
        case .Ho: return .Ho
        case .Er: return .Er
        case .Tm: return .Tm
        case .Yb: return .Yb
        case .Lu: return .Lu
        case .Hf: return .Hf
        case .Ta: return .Ta
        case  .W: return .W
        case .Re: return .Re
        case .Os: return .Os
        case .Ir: return .Ir
        case .Pt: return .Pt
        case .Au: return .Au
        case .Hg: return .Hg
        case .Tl: return .Tl
        case .Pb: return .Pb
        case .Bi: return .Bi
        case .Po: return .Po
        case .At: return .At
        case .Rn: return .Rn

        case .Fr: return .Fr
        case .Ra: return .Ra
        case .Ac: return .Ac
        case .Th: return .Th
        case .Pa: return .Pa
        case  .U: return .U
        case .Np: return .Np
        case .Pu: return .Pu
        case .Am: return .Am
        case .Cm: return .Cm
        case .Bk: return .Bk
        case .Cf: return .Cf
        case .Es: return .Es
        case .Fm: return .Fm
        case .Md: return .Md
        case .No: return .No
        case .Lr: return .Lr
        case .Rf: return .Rf
        case .Db: return .Db
        case .Sg: return .Sg
        case .Bh: return .Bh
        case .Hs: return .Hs
        case .Mt: return .Mt
        case .Ds: return .Ds
        case .Rg: return .Rg
        case .Cn: return .Cn
        case .Nh: return .Nh
        case .Fl: return .Fl
        case .Mc: return .Mc
        case .Lv: return .Lv
        case .Ts: return .Ts
        case .Og: return .Og

        case .D: return .H
            
        default: break
        }
        return .unknown
    }

}

extension AtomicSymbol {

    func toAtomicProperty() -> AtomicProperty {

        switch self {
        case .Li,.Na,.K,.Rb,.Cs,.Fr:
            return .alkaliMetal
        case .Be,.Mg,.Ca,.Sr,.Ba,.Ra:
            return .alkalineEarth
        case .Sc,.Ti,.V,.Cr,.Mn,.Fe,.Co,.Ni,.Cu,.Zn,
             .Y,.Zr,.Nb,.Mo,.Tc,.Ru,.Rh,.Pd,.Ag,.Cd,
             .Hf,.Ta,.W,.Re,.Os,.Ir,.Pt,.Au,.Hg,
             .Rf,.Db,.Sg,.Bh,.Hs,.Mt,.Ds,.Rg,.Cn:
            return .transitionMetal
        case .Al,.Ga,.In,.Sn,.Tl,.Pb,.Bi,.Fl,.Lv:
            return .basicMetal
        case .B,.Si,.Ge,.As,.Sb,.Te,.Po:
            return .semimetal
        case .D,.C,.N,.O,.P,.S,.Se:
            return .nonmetal
        case .F,.Cl,.Br,.I,.At:
            return .halogen
        case .He,.Ne,.Ar,.Kr,.Xe,.Rn:
            return .nobleGas
        case .La,.Ce,.Pr,.Nd,.Pm,.Sm,.Eu,.Gd,.Tb,.Dy,.Ho,.Er,.Tm,.Yb,.Lu:
            return .lanthanide
        case .Ac,.Th,.Pa,.U,.Np,.Pu,.Am,.Cm,.Bk,.Cf,.Es,.Fm,.Md,.No,.Lr:
            return .actinide
        default:
            return .unknown
        }

    }
}

func < ( l: AtomicNumber, r: AtomicNumber ) -> Bool {
    return l.rawValue < r.rawValue
}
func > ( l: AtomicNumber, r: AtomicNumber ) -> Bool {
    return l.rawValue > r.rawValue
}

func < ( l: AtomicSymbol, r: AtomicSymbol ) -> Bool {
    return l.toAtomicNumber() < r.toAtomicNumber()
}
func > ( l: AtomicSymbol, r: AtomicSymbol ) -> Bool {
    return l.toAtomicNumber() > r.toAtomicNumber()
}

