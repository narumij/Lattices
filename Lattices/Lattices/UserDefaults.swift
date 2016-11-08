//
//  UserDefaults.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/30.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension AppDelegate {
    func registerDefaults() {

        var defaults : [ String : AnyObject ] = [
            AppDelegateDefaultsRadiiModeKey: RadiiType.Covalent.rawValue as AnyObject,
            AppDelegateDefaultsRadiiSizeKey:1.0 as AnyObject,
            LatticesDefaultsBondSize:0.25 as AnyObject,
            AppDelegateDefaultsUsesOrthographic:true as AnyObject,
            DocumentDefaultsLoadColorAndRadiiKey:true as AnyObject,
            DocumentDefaultsLoadCameraKey:true as AnyObject,
            DocumentDefaultsLoadBondExpansionKey:true as AnyObject,
            LatticesDefaultsUsesBonding:true as AnyObject,
//            LatticesDefaultsUsesGeomBondAtoms:false,
            LatticesDefaultsInitialAnimationDurationKey:1.0 as AnyObject,
            //            AppDelegateDefaultsBondingModeKey: SwiftCrystal.BondingMode.ColoredCylindar.rawValue,
            LatticesDefaultsInitialBondExpansionKey: SwiftCrystal.BondingRangeMode.UnitCell.rawValue as AnyObject
            ]

        if UIScreen.main.scale == 1.0 {
            defaults[LatticesDefaultsUsesBonding] = false as AnyObject?
        }

        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: defaults)

    }
    
    func reflectSettingsBundle() {

        let userDefaults = UserDefaults.standard

        if let radiiFileName = userDefaults.string(forKey: AppDelegateDefaultsRadiiModeKey) {
            SwiftCrystal.stdRadiiType = RadiiType( rawValue: radiiFileName ) ?? .Covalent
        }

        let radiiSize = userDefaults.double(forKey: AppDelegateDefaultsRadiiSizeKey)
        SwiftCrystal.stdRadiiSize = RadiiSizeType(radiiSize)

        let bondSize = userDefaults.double(forKey: LatticesDefaultsBondSize)
        SwiftCrystal.stdBondSize = RadiiSizeType(bondSize)

        let usesOrthographic = userDefaults.bool(forKey: AppDelegateDefaultsUsesOrthographic)
        CameraInitial.stdUsesOrthographic = usesOrthographic

        if let bondingRange = userDefaults.string( forKey: LatticesDefaultsInitialBondExpansionKey ) {
            SwiftCrystal.DefaultBondingRangeMode = SwiftCrystal.BondingRangeMode( rawValue: bondingRange ) ?? .OneStep
        }
//        let usesGeomBondAtoms = userDefaults.boolForKey(LatticesDefaultsUsesGeomBondAtoms)
//        SwiftCrystal.UsesGeomBondAtoms = usesGeomBondAtoms

        let loadColorAndRadii = userDefaults.bool(forKey: DocumentDefaultsLoadColorAndRadiiKey)
        Document.loadColorAndRadii = loadColorAndRadii

        let loadCamera = userDefaults.bool(forKey: DocumentDefaultsLoadCameraKey)
        Document.loadCamera = loadCamera

        let loadBondExpansion = userDefaults.bool(forKey: DocumentDefaultsLoadBondExpansionKey)
        Document.loadBondExpansion = loadBondExpansion

        let usesBonding = userDefaults.bool(forKey: LatticesDefaultsUsesBonding)
        SwiftCrystal.DefaultBondingMode = usesBonding ? .On : .Off

        let initialAnimationDuration = userDefaults.double(forKey: LatticesDefaultsInitialAnimationDurationKey)
        Document.initialAnimationDuration = initialAnimationDuration
    }

}



let kMainStoryboardName = "Main"
let kSaveRecieveURLViewControllerIdentifier = "SaveRecieveURLViewController"

// Default Identifiers



let AppDelegateDefaultsRadiiModeKey = "RadiiModeKey"
let AppDelegateDefaultsRadiiSizeKey = "RadiiSizeKey"
let LatticesDefaultsBondSize = "BondSize"
let AppDelegateDefaultsUsesOrthographic = "UsesOrthographic"
let LatticesDefaultsUsesBonding = "UsesBonding"
//let LatticesDefaultsUsesGeomBondAtoms = "LatticesDefaultsUsesGeomBondAtoms"
let LatticesDefaultsInitialAnimationDurationKey = "InitialAnimationDurationKey"
let LatticesDefaultsInitialBondExpansionKey = "InitialBondExpansionKey"

let DocumentDefaultsLoadColorAndRadiiKey = "LoadColorAndRadiiKey"
let DocumentDefaultsLoadBondExpansionKey = "LoadBondExpansionKey"
let DocumentDefaultsLoadCameraKey = "LoadCameraKey"

//let AppDelegateSubscriptionTestKey = "AppDelegateSubscriptionTestKey"

// Notifications
extension AppDelegate {
//    static let didFinishLoadDocument = Notification.Name(rawValue:"didFinishLoadDocument")
}

let AppDelegateDidFinishOpenURLNotification = "AppDelegateDidFinishOpenURLNotification"
let AppDelegateDidUpdateDocumentsNotification = "AppDelegateDidUpdateDocumentsNotification"

let latticesMenuWillAppear = Notification.Name(rawValue:"latticesMenuWillAppear")
let latticesMenuWillDisappear = Notification.Name(rawValue:"latticesMenuWillDisappear")





