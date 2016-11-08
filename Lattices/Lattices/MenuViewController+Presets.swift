//
//  MenuViewControllerPresets.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

typealias preset_t = (title:String,radii:RadiiSizeType,bond:RadiiSizeType,type:RadiiType,condition:()->Bool)

extension MenuViewController {
    static func needsShowBondItems() -> Bool {
        return SharedAppDelegate().currentDocument?.crystal.concrete.bonds.count ?? 0 > 0
    }

    static func needsShowDisplacementItems() -> Bool {
        return SharedAppDelegate().currentDocument?.crystal.info.hasDisplacement ?? false
    }
}

let presets : [preset_t] = [
    ("Line", 0, 0, .Unit,
        { return MenuViewController.needsShowBondItems() }),
    ("Stick", 0.05, 1, .Unit,
        { return MenuViewController.needsShowBondItems() }),
    ("Ball & Stick", 0.5, 0.5, .Covalent,
        { return MenuViewController.needsShowBondItems() }),
    ("Ellipsoid", sliderValue( from: 0.5 ), 0.25, .Ellipsoid,
        { return MenuViewController.needsShowDisplacementItems() }),
    ("Van-der-Waals", 1.0, 0.0, .Van_der_Waals,
        { return true })
]

extension MenuViewController {

    func presetOf( _ title : String ) -> preset_t? {
        return presets.filter({ $0.title == title }).first
    }

    @IBAction func presetAction( _ sender : AnyObject? ) {
        let idx = (sender as! UIView).tag
        if !isPresetSelected( presets[ idx ] ) {
            setPreset( presets[ idx ] )
            document?.updateChangeCount(.done)
        }
    }

    func setPreset( _ preset: preset_t ) {
        if let crystal = crystal {
            updateContentsWithAnimation(duration:0.5){
                crystal.radiiSize = preset.radii
                crystal.bondSize = preset.bond
                crystal.radiiType = preset.type
            }
        }
    }

    func isPresetSelected( _ p: preset_t ) -> Bool {
        return crystal?.radiiSize == p.radii
            && crystal?.bondSize == p.bond
            && crystal?.radiiType == p.type
    }

    func updatePresets() {
        _ = updatePresetProcs.map{ $0() }
    }

    func preparePresetMode() {
        preset.axis = .vertical
        mainStackView.addArrangedSubview(preset)
        preset.addArrangedSubview( lineView() )
        preset.addArrangedSubview( spaceView(lineSpace) )
        preset.addArrangedSubview( titleView("Preset") )
        for i in [0,1,4,2,3] {
            let p = presets[i]
            if p.condition() {
                let item = itemView( p.title, action: #selector(presetAction), tag: i )
                updatePresetProcs.append( { [weak self] in item.selected = self?.isPresetSelected(p) ?? false } )
                preset.addArrangedSubview( item )
            }
        }
        preset.addArrangedSubview( spaceView( 12 ) )
    }
}
