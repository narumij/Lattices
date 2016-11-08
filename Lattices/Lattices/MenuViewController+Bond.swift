//
//  MenuViewControllerBond.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension MenuViewController {

    func bondAction( _ mode: SwiftCrystal.BondingRangeMode, sender: UIButton? ) {

        if crystal?.bondingRangeMode != mode {

            let itemView =
                   sender?.superview as? ItemView
                ?? sender?.superview?.superview as? ItemView

            itemView?.startAnimating()
            updateContentsWithAnimation(duration:0.0){
                crystal?.bondingRangeMode = mode
            }
            itemView?.stopAnimating()
            document?.updateChangeCount(.done)

        }

//        SharedAppDelegate().currentDocument?.crystal.cameraRig.refresh()

    }

    @IBAction func bond0Action( _ sender: UIButton? ) { bondAction( .UnitCell, sender: sender ) }
    @IBAction func bond1Action( _ sender: UIButton? ) { bondAction( .OneStep,  sender: sender ) }
    @IBAction func bond2Action( _ sender: UIButton? ) { bondAction( .Grouping, sender: sender ) }
    @IBAction func bond3Action( _ sender: UIButton? ) { bondAction( .Limited,  sender: sender ) }
    @IBAction func bond4Action( _ sender: UIButton? ) { bondAction( .Site,  sender: sender ) }

    func removeDiaSlider() {
//        mainStackView.removeArrangedSubview(bondDiaBackground)
//        mainStackView.removeArrangedSubview(bondDiaSpacer)
        bondDiaBackground.isHidden = true
        bondDiaSpacer.isHidden = true
    }

    func prepareBondView() {

        var menuData : [(String,Selector,Int,SwiftCrystal.BondingRangeMode)] = [
            ("Unit Cell",#selector(bond0Action),0,.UnitCell),
            ("One Step",#selector(bond1Action),1,.OneStep),
            ("Grouping",#selector(bond2Action),2,.Grouping),
            ("Chain",#selector(bond3Action),3,.Limited)
        ]

        if crystal?.bondingMode == .Off {
            removeDiaSlider()
            menuData = [ ("Unit Cell",#selector(bond0Action),0,.UnitCell) ]
        }

        if crystal?.info.geomBonds.count == 0 {
            removeDiaSlider()
            menuData = [ ("Unit Cell",#selector(bond0Action),0,.UnitCell) ]
        }

        bondView.axis = .vertical
        mainStackView.addArrangedSubview(bondView)
        bondView.addArrangedSubview( lineView() )
        bondView.addArrangedSubview( spaceView(lineSpace) )
        bondView.addArrangedSubview( titleView("Bond Expansion") )
        _ = menuData.map{
            let item = itemView($0.0, action: $0.1, tag: $0.2)
            bondItems.append( ($0.3,item) )
            bondView.addArrangedSubview( item )
        }
        bondView.addArrangedSubview( spaceView(12) )
    }

    func updateBondView() {
        let bondMode = crystal?.bondingRangeMode ?? .UnitCell
        let enabled = !SharedAppDelegate().workProgressController.working
        for (_,item) in bondItems {
            item.selected = false
            item.enabled = enabled
        }
        _ = bondItems.map{
            if $0.0 == bondMode {
                $0.1.selected = true
                $0.1.enabled = false
            }
        }
    }
}
