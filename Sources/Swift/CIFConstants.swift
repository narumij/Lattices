//
//  CIFConstants.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension CrystalCell_t {
    enum CIFTag : String {
        case A = "_cell_length_a"
        case B = "_cell_length_b"
        case C = "_cell_length_c"
        case Alpha = "_cell_angle_alpha"
        case Beta = "_cell_angle_beta"
        case Gamma = "_cell_angle_gamma"
    }
}

extension CrystalSymmetryOperation_t {
    enum CIFTag : String {
        case PosAsXYZ = "_symmetry_equiv_pos_as_xyz"
        case OperationXYZ = "_space_group_symop_operation_xyz"
        case symHM = "_symmetry_space_group_name_H-M"
        case symHall = "_symmetry_space_group_name_Hall"
        case HMAlt = "_space_group_name_H-M_alt"
        case Hall = "_space_group_name_Hall"
    }
}

extension CrystalAtomSite_t {
    enum CIFTag : String {
        case Label = "_atom_site_label"
        case TypeSymbol = "_atom_site_type_symbol"
        case FractX = "_atom_site_fract_x"
        case FractY = "_atom_site_fract_y"
        case FractZ = "_atom_site_fract_z"
        case AdpType = "_atom_site_adp_type"
        case ThermalDisplaceType = "_atom_site_thermal_displace_type"
        case Uiso = "_atom_site_U_iso_or_equiv"
        case UisoEquiv = "_atom_site_U_equiv_geom_mean"
        case Biso = "_atom_site_B_iso_or_equiv"
        case BisoEquiv = "_atom_site_B_equiv_geom_mean"
        case Occupancy = "_atom_site_occupancy"
        #if false
        static var All : [CIFTag] {
        return [ .Label, .TypeSymbol, .FractX, .FractY, .FractZ ]
        }
        #endif
        static var All : [CIFTag] {
            return [ .Label, .TypeSymbol,
                     .FractX, .FractY, .FractZ,
                     .AdpType, .ThermalDisplaceType,
                     .Uiso, .UisoEquiv,
                     .Biso, .BisoEquiv,
                     .Occupancy ]
        }
    }
}

extension CrystalAtomType_t {
    enum CIFTag : String {
        case Symbol = "_atom_type_symbol"
        case RadiusBond = "_atom_type_radius_bond"
        static var All : [CIFTag] {
            return [ .Symbol, .RadiusBond ]
        }
    }
}

extension CrystalAtomSiteAniso_t {
    enum CIFTag : String {
        case TypeSymbol = "_atom_site_aniso_type_symbol"
        case Label = "_atom_site_aniso_label"
        case Ratio = "_atom_site_aniso_ratio"
        case U11 = "_atom_site_aniso_U_11"
        case U12 = "_atom_site_aniso_U_12"
        case U13 = "_atom_site_aniso_U_13"
        case U22 = "_atom_site_aniso_U_22"
        case U23 = "_atom_site_aniso_U_23"
        case U33 = "_atom_site_aniso_U_33"
        case B11 = "_atom_site_aniso_B_11"
        case B12 = "_atom_site_aniso_B_12"
        case B13 = "_atom_site_aniso_B_13"
        case B22 = "_atom_site_aniso_B_22"
        case B23 = "_atom_site_aniso_B_23"
        case B33 = "_atom_site_aniso_B_33"
        static var All : [CIFTag] {
            return [
                .TypeSymbol, .Label, .Ratio,
                .U11, .U12, .U13, .U22, .U23, .U33,
                .B11, .B12, .B13, .B22, .B23, .B33
            ]
        }
    }
}

extension CrystalGeomAngle_t {
    enum CIFTag : String {
        case Angle = "_geom_angle"
        case PublFlag = "_geom_angle_publ_flag"
        case Label1 = "_geom_angle_atom_site_label_1"
        case Label2 = "_geom_angle_atom_site_label_2"
        case Label3 = "_geom_angle_atom_site_label_3"
        case SiteSymmetry1 = "_geom_angle_site_symmetry_1"
        case SiteSymmetry2 = "_geom_angle_site_symmetry_2"
        case SiteSymmetry3 = "_geom_angle_site_symmetry_3"
        static var All : [CIFTag] {
            return [
                .Angle, .PublFlag,
                .Label1, .Label2, .Label3,
                .SiteSymmetry1, .SiteSymmetry2, .SiteSymmetry3
            ]
        }
    }
}

extension CrystalGeomBond_t {
    enum CIFTag : String {
        case Distance = "_geom_bond_distance"
        case PublFlag = "_geom_bond_publ_flag"
        case Label1 = "_geom_bond_atom_site_label_1"
        case Label2 = "_geom_bond_atom_site_label_2"
        case SiteSymmetry1 = "_geom_bond_site_symmetry_1"
        case SiteSymmetry2 = "_geom_bond_site_symmetry_2"
        static var All : [CIFTag] {
            return [
                .Distance, .PublFlag,
                .Label1, .Label2,
                .SiteSymmetry1, .SiteSymmetry2
            ]
        }
    }
}

extension CrystalGeomContact_t {
    enum CIFTag : String {
        case Distance = "_geom_contact_distance"
        case PublFlag = "_geom_contact_publ_flag"
        case Label1 = "_geom_contact_atom_site_label_1"
        case Label2 = "_geom_contact_atom_site_label_2"
        case SiteSymmetry1 = "_geom_contact_site_symmetry_1"
        case SiteSymmetry2 = "_geom_contact_site_symmetry_2"
        static var All : [CIFTag] {
            return [
                .Distance, .PublFlag,
                .Label1, .Label2,
                .SiteSymmetry1, .SiteSymmetry2
            ]
        }
    }
}

extension CrystalGeomHBond_t {
    enum CIFTag : String {
        case AngleDHA = "_geom_hbond_angle_DHA"
        case LabelD = "_geom_hbond_atom_site_label_D"
        case LabelH = "_geom_hbond_atom_site_label_H"
        case LabelA = "_geom_hbond_atom_site_label_A"
        case DistanceDH = "_geom_hbond_distance_DH"
        case DistanceHA = "_geom_hbond_distance_HA"
        case DistanceDA = "_geom_hbond_distance_DA"
        case PublFlag = "_geom_hbond_publ_flag"
        case SiteSymmetryD = "_geom_hbond_site_symmetry_D"
        case SiteSymmetryH = "_geom_hbond_site_symmetry_H"
        case SiteSymmetryA = "_geom_hbond_site_symmetry_A"
        static var All : [CIFTag] {
            return [
                .AngleDHA,
                .LabelD, .LabelH, LabelA,
                .DistanceDH, .DistanceHA, .DistanceDA,
                .PublFlag,
                .SiteSymmetryD, .SiteSymmetryH, .SiteSymmetryA
            ]
        }
    }
}

extension CrystalGeomTorsion_t {
    enum CIFTag : String {
        case Torsion = "_geom_torsion"
        case PublFlag = "_geom_torsion_publ_flag"
        case Label1 = "_geom_torsion_atom_site_label_1"
        case Label2 = "_geom_torsion_atom_site_label_2"
        case Label3 = "_geom_torsion_atom_site_label_3"
        case Label4 = "_geom_torsion_atom_site_label_4"
        case SiteSymmetry1 = "_geom_torsion_site_symmetry_1"
        case SiteSymmetry2 = "_geom_torsion_site_symmetry_2"
        case SiteSymmetry3 = "_geom_torsion_site_symmetry_3"
        case SiteSymmetry4 = "_geom_torsion_site_symmetry_4"
        static var All : [CIFTag] {
            return [
                .Torsion, .PublFlag,
                .Label1, .Label2, .Label3, .Label4,
                .SiteSymmetry1, .SiteSymmetry2, .SiteSymmetry3, .SiteSymmetry4
            ]
        }
    }
}

protocol CIFTagAll {
    static var All:[Self] { get }
}

protocol CIFTagInit {
    associatedtype CIFTag : Hashable
    init( _ values: [ CIFTag : String ] )
}

extension CrystalAtomType_t.CIFTag: CIFTagAll {
}
extension CrystalAtomType_t: CIFTagInit {
}
extension CrystalAtomSite_t.CIFTag: CIFTagAll {
}
extension CrystalAtomSite_t: CIFTagInit {
}
extension CrystalAtomSiteAniso_t.CIFTag: CIFTagAll {
}
extension CrystalAtomSiteAniso_t: CIFTagInit {
}
extension CrystalGeomAngle_t.CIFTag: CIFTagAll {
}
extension CrystalGeomAngle_t: CIFTagInit {
}
extension CrystalGeomBond_t.CIFTag: CIFTagAll {
}
extension CrystalGeomBond_t: CIFTagInit {
}
extension CrystalGeomContact_t.CIFTag: CIFTagAll {
}
extension CrystalGeomContact_t: CIFTagInit {
}
extension CrystalGeomHBond_t.CIFTag: CIFTagAll {
}
extension CrystalGeomHBond_t: CIFTagInit {
}
extension CrystalGeomTorsion_t.CIFTag: CIFTagAll {
}
extension CrystalGeomTorsion_t: CIFTagInit {
}


