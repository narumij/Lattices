//
//  MenuViewController+Labels.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

private let labelData: [(SwiftCrystal.LabelMode,String)] = [
    (.nothing,"Off"),
//    (.AtomicSymbol,"AtomicSymbol"),
    (.typeSymbol,"TypeSymbol"),
    (.siteLabel,"SiteLabel"),
    (.symmetryCode,"Symmetry Code"),
    (.multiplicity,"Multiplicity"),
    (.siteSymmetry,"Site Symmetry"),
    (.wyckoffLetter,"Wyckoff Letter"),
    (.occupancy,"Occupancy"),
    (.xyz,"SiteXYZ"),
    (.fract,"Fractional"),
    (.cartn,"Cartesian"),
    (.bondDistance,"Bond distance"),
]

extension MenuViewController {

    @IBAction func labelAction( _ sender: UIButton? ) {
        if let tag = sender?.tag {
            let data = labelData[tag]
            crystal?.labelMode = data.0
//            let linePreset = ( data.0 != .BondDistance ) ? presets[1] : ( "bond distance", 0.1, 0.0, .Unit, {return true} )
            let linePreset = presets[1]
            if !isPresetSelected(linePreset) {
                setPreset(linePreset)
            }
        }
        updateUI()
        crystal?.camera.refresh()
    }

    func updateLabels() {
        if let labelMode = crystal?.labelMode {
            _ = labelItems.map{
                if $0.0 == labelMode {
                    $0.1.selected = true
                    $0.1.enabled = false
                }
                else {
                    $0.1.selected = false
                    $0.1.enabled = true
                }
            }
        }
    }

}

extension MenuViewController {

    func prepareLabels() {
        labels.axis = .vertical
        mainStackView.addArrangedSubview( labels )
        labels.addArrangedSubview( lineView() )
        labels.addArrangedSubview( spaceView(lineSpace) )
        labels.addArrangedSubview( titleView("(Label Test)") )
        labelItems = labelData.enumerated().map({
            let item = itemView( $0.element.1, action: #selector(labelAction), tag: $0.offset )
            labelItems.append(($0.element.0,item))
            labels.addArrangedSubview( item )
            return item
        })
        labels.addArrangedSubview( spaceView(12) )
    }

}


