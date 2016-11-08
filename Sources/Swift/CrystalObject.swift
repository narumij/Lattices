//
//  CrystalObject.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/20.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class CrystalSymmetryOperation_t {
    var matrix4x4:Matrix4x4
    var index:Int
    var replaced = false

    init(XYZ:String,index:Int){
        self.matrix4x4 = XYZParse(XYZ)
        self.index = index
    }

    init(matrix:Matrix4x4,index:Int){
        self.matrix4x4 = matrix
        self.index = index
    }

    var posn: Int {
        return index + 1
    }
    var matrix3x3 : Matrix3x3 {
        var m4 = matrix4x4
        var m3 = Matrix3x3()
        for i in 0..<3 {
            for j in 0..<3 {
                m3[i][j] = m4[i,j]
            }
        }
        return m3
    }
    var rotate : Matrix4x4 {
        var m = matrix4x4
        m[3,0] = 0
        m[3,1] = 0
        m[3,2] = 0
        m[0,3] = 0
        m[1,3] = 0
        m[2,3] = 0
        m[3,3] = 1
        var mat3 = Matrix3x3()
        for i in 0..<3 {
            for j in 0..<3 {
                mat3[i][j] = m[i,j]
            }
        }
        let det = matrix_determinant( mat3.cmatrix )
        if det == -1 {
            m[3,3] = -1
        }
        return m
    }
    var isIdentity: Bool {
        return matrix4x4 == Matrix4x4Identity
    }
    var xyz: String {
        return xyzDescription(fromMatrix4x4(matrix4x4))
    }
}

func isEquiv( _ symmetryOperations: [CrystalSymmetryOperation_t], _ symopMatrices: [Matrix4x4] ) -> Bool {
    var symopMatrices = symopMatrices
    for symop in symmetryOperations {
        let mat = symop.matrix4x4
        if let idx = symopMatrices.index(of: mat) {
            symopMatrices.remove(at: idx)
        }
        else {
            return false
        }
    }
    return symopMatrices.count == 0
}

class CrystalAtomType_t : Equatable {

    var atomicSymbol : AtomicSymbol { return AtomicSymbol( symbol: symbol ) ?? .unknown }
    var symbol : String = ""
    var radiusBond : FloatType?
    var name : AtomicName { return atomicSymbol.toAtomicName() }

    var index : Int = 0

    init( site: CrystalAtomSite_t ) {
        symbol = site.typeSymbol.length != 0 ? site.typeSymbol : site.atomicSymbol.rawValue
    }

    required init( _ values: [CIFTag:String] ) {
        if let value = values[.Symbol] {
            symbol = value
        }
        if let value = values[.RadiusBond] {
            if value != "?" && value != "." {
                radiusBond = value.floatTypeValue
            }
        }
    }

    weak var scene: SceneType_t?
}

extension CrystalAtomType_t {
    var localizedName : String? {
        return NSLocalizedString( name.rawValue,
                                  tableName: "ElementName",
                                  bundle: Bundle.main,
                                  value: name.rawValue,
                                  comment: "")
    }
}

func == (lhs: CrystalAtomType_t, rhs: CrystalAtomType_t) -> Bool {
    return lhs.symbol == rhs.symbol
}

enum CrystalAtomSiteAdpType : String {
    case Uani
    case Uiso
    case Uovl
    case Umpe
    case Bani
    case Biso
    case Bovl
}

class CrystalAtomSite_t {

    var label : String
    var typeSymbol : String
    var atomicSymbol : AtomicSymbol
    var fract : Vector3
    var adpType : CrystalAtomSiteAdpType?
    var Biso : Biso_t?
    var Uiso : Uiso_t?
    var occupancy: FloatType?

    var wyckoff: WyckoffItem?

    var index : Int = 0

    required init( _ values: [CIFTag:String] ) {
//        func fractCoord( values: [CIFTag:String] ) -> FractCoord_t {
//            return FractCoord_t(
//                values[.FractX]?.floatTypeValue ?? 0.0,
//                values[.FractY]?.floatTypeValue ?? 0.0,
//                values[.FractZ]?.floatTypeValue ?? 0.0
//            )
//        }
        func fractCoord( _ values: [CIFTag:String] ) -> Vector3 {
            return Vector3(
                values[.FractX]?.floatTypeValue ?? 0.0,
                values[.FractY]?.floatTypeValue ?? 0.0,
                values[.FractZ]?.floatTypeValue ?? 0.0
            )
        }
        label = values[.Label] ?? ""
        typeSymbol = values[.TypeSymbol] ?? ""
        fract = fractCoord( values )
        atomicSymbol = AtomicSymbol( symbol: typeSymbol, label: label ) ?? .unknown
        adpType = CrystalAtomSiteAdpType( rawValue: values[.AdpType] ?? values[.ThermalDisplaceType] ?? "" )
        occupancy = values[.Occupancy]?.floatTypeValue
        if let b = values[.Biso] ?? values[.BisoEquiv] {
            Biso = Iso( isoOrEquiv: b.floatTypeValue )
        }
        if let u = values[.Uiso] ?? values[.UisoEquiv] {
            Uiso = Iso( isoOrEquiv: u.floatTypeValue )
        }
    }

    convenience init( _ values: [CIFTag:String], index i: Int ) {
        self.init(values)
        index = i
    }

    var type: CrystalAtomType_t?
}

func == (l:CrystalAtomSite_t,r:CrystalAtomSite_t) -> Bool {
    return l === r
}

extension CrystalAtomSite_t : Equatable {
}

func < (l:CrystalAtomSite_t,r:CrystalAtomSite_t) -> Bool {
    return l.index < r.index || ( l.index == r.index && l.atomicSymbol < r.atomicSymbol )
}

func > (l:CrystalAtomSite_t,r:CrystalAtomSite_t) -> Bool {
    return l.index > r.index || ( l.index == r.index && l.atomicSymbol > r.atomicSymbol )
}

extension CrystalSymmetryOperation_t {
    func clamped( _ site: CrystalAtomSite_t ) -> Vector3 {
        return simd.fract( matrix4x4 * vector4( site.fract, 1 ) ).xyz
    }
}


//extension CrystalAtomSite {
//    func clamped( symop: CrystalSymmetryOperation ) -> Vector3 {
//        return simd.fract( symop.matrix4x4 * Vector4( fract.pos, 1 ) ).xyz
//    }
//}


class CrystalAtomSiteAniso_t {
    var label : String = ""
    var typeSymbol : String?
    var ratio : FloatType = 1.0
    var B : Bani_t?
    var U : Uani_t?
    init() {
    }
    required init( _ values: [CIFTag:String] ) {
        typeSymbol = values[.TypeSymbol]
        label = values[.Label] ?? ""
        ratio = values[.Ratio]?.floatTypeValue ?? 1.0
        B = hasB( values ) ? Aniso( b: values ) : nil
        U = hasU( values ) ? Aniso( u: values ) : nil
    }
    fileprivate func hasB( _ values: [CIFTag:String] ) -> Bool {
        return values[.B11] != nil && values[.B22] != nil && values[.B33] != nil
    }
    fileprivate func hasU( _ values: [CIFTag:String] ) -> Bool {
        return values[.U11] != nil && values[.U22] != nil && values[.U33] != nil
    }
    func isMatch( with site: CrystalAtomSite_t ) -> Bool {
        return typeSymbol == nil
            ? label == site.label
            : label == site.label && typeSymbol == site.typeSymbol
    }
}

class CrystalGeomAngle_t {
    var angle: AngleNumeric_t?
    var atomSiteLabel1: String?
    var atomSiteLabel2: String?
    var atomSiteLabel3: String?
    var publFlag: PublFlag_t?
    var siteSymmetry1: SymmetryCode_t
    var siteSymmetry2: SymmetryCode_t
    var siteSymmetry3: SymmetryCode_t
    required init( _ values: [ CIFTag : String ] ) {
        atomSiteLabel1 = values[.Label1]
        atomSiteLabel2 = values[.Label2]
        atomSiteLabel3 = values[.Label3]
        angle          = values[.Angle]?.angleNumericValue
        siteSymmetry1  = SymmetryCode_t( values[.SiteSymmetry1] )
        siteSymmetry2  = SymmetryCode_t( values[.SiteSymmetry2] )
        siteSymmetry3  = SymmetryCode_t( values[.SiteSymmetry3] )
        publFlag       = values[.PublFlag]?.publFlagValue
    }
    var siteCondition1 : SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabel1, symmetryCode: siteSymmetry1 )
    }
    var siteCondition2 : SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabel2, symmetryCode: siteSymmetry2 )
    }
    var siteCondition3 : SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabel3, symmetryCode: siteSymmetry3 )
    }
}

class CrystalGeomBond_t {
    var atomSiteLabel1: String?
    var atomSiteLabel2: String?
    var distance: DistanceNumeric_t?
    var siteSymmetry1: SymmetryCode_t
    var siteSymmetry2: SymmetryCode_t
    fileprivate var publFlag: PublFlag_t?
    var isPublic: Bool {
        return isValid && publFlag == true
    }
    var isValid: Bool {
        return true
    }
    var siteSymmetryCode1: SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabel1, symmetryCode: siteSymmetry1 )
    }
    var siteSymmetryCode2: SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabel2, symmetryCode: siteSymmetry2 )
    }
    required init( _ values: [ CIFTag : String ] ) {
        atomSiteLabel1 = values[.Label1]
        atomSiteLabel2 = values[.Label2]
        distance       = values[.Distance]?.distanceNumericValue
        siteSymmetry1  = SymmetryCode_t( values[.SiteSymmetry1] )
        siteSymmetry2  = SymmetryCode_t( values[.SiteSymmetry2] )
        publFlag       = values[.PublFlag]?.publFlagValue
    }
}


class CrystalGeomContact_t {
    var distance: DistanceNumeric_t?
    var atomSiteLabel1: String?
    var atomSiteLabel2: String?
    var publFlag: PublFlag_t?
    var siteSymmetry1: SymmetryCode_t
    var siteSymmetry2: SymmetryCode_t
    required init( _ values: [ CIFTag : String ] ) {
        atomSiteLabel1 = values[.Label1]
        atomSiteLabel2 = values[.Label2]
        distance       = values[.Distance]?.distanceNumericValue
        siteSymmetry1  = SymmetryCode_t( values[.SiteSymmetry1] )
        siteSymmetry2  = SymmetryCode_t( values[.SiteSymmetry2] )
        publFlag       = values[.PublFlag]?.publFlagValue
    }
}


class CrystalGeomHBond_t {
    var angleDHA : AngleNumeric_t?
    var atomSiteLabelD : String?
    var atomSiteLabelH : String?
    var atomSiteLabelA : String?
    var distanceDH : DistanceNumeric_t?
    var distanceHA : DistanceNumeric_t?
    var distanceDA : DistanceNumeric_t?
    var siteSymmetryD : SymmetryCode_t
    var siteSymmetryH : SymmetryCode_t
    var siteSymmetryA : SymmetryCode_t
    fileprivate var publFlag : PublFlag_t?
    var isPublic : Bool {
        return isValid && publFlag == true
    }
    var isValid : Bool {
        return true
    }
    required init( _ values: [ CIFTag : String ] ) {
        angleDHA       = values[.AngleDHA]?.angleNumericValue
        atomSiteLabelD = values[.LabelD]
        atomSiteLabelH = values[.LabelH]
        atomSiteLabelA = values[.LabelA]
        distanceDH     = values[.DistanceDH]?.distanceNumericValue
        distanceHA     = values[.DistanceHA]?.distanceNumericValue
        distanceDA     = values[.DistanceDA]?.distanceNumericValue
        siteSymmetryD  = SymmetryCode_t( values[.SiteSymmetryD] )
        siteSymmetryH  = SymmetryCode_t( values[.SiteSymmetryH] )
        siteSymmetryA  = SymmetryCode_t( values[.SiteSymmetryA] )
        publFlag       = values[.PublFlag]?.publFlagValue
    }
    var siteSymmetryCodeD : SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabelD, symmetryCode: siteSymmetryD )
    }
    var siteSymmetryCodeH : SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabelH, symmetryCode: siteSymmetryH )
    }
    var siteSymmetryCodeA : SiteSymmetryCode_t {
        return SiteSymmetryCode_t( label: atomSiteLabelA, symmetryCode: siteSymmetryA )
    }
}


class CrystalGeomTorsion_t {
    var torsion: AngleNumeric_t?
    var atomSiteLabel1: String?
    var atomSiteLabel2: String?
    var atomSiteLabel3: String?
    var atomSiteLabel4: String?
    var publFlag: PublFlag_t?
    var siteSymmetry1: SymmetryCode_t
    var siteSymmetry2: SymmetryCode_t
    var siteSymmetry3: SymmetryCode_t
    var siteSymmetry4: SymmetryCode_t
    required init( _ values: [ CIFTag : String ] ) {
        atomSiteLabel1 = values[.Label1]
        atomSiteLabel2 = values[.Label2]
        atomSiteLabel3 = values[.Label3]
        atomSiteLabel4 = values[.Label4]
        torsion        = values[.Torsion]?.angleNumericValue
        siteSymmetry1  = SymmetryCode_t( values[.SiteSymmetry1] )
        siteSymmetry2  = SymmetryCode_t( values[.SiteSymmetry2] )
        siteSymmetry3  = SymmetryCode_t( values[.SiteSymmetry3] )
        siteSymmetry4  = SymmetryCode_t( values[.SiteSymmetry4] )
        publFlag       = values[.PublFlag]?.publFlagValue
    }
}
















