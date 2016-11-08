//
//  MenuViewControllerRadii.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension MenuViewController {

    func radiiAction( _ radiiType: RadiiType ) {
        if crystal?.radiiType != radiiType {
            updateContentsWithAnimation(duration:0.5){
                crystal?.radiiType = radiiType
            }
            document?.updateChangeCount(.done)
        }
    }

    @IBAction func radii0Action( _ sender: AnyObject? ) { radiiAction(.Calculated) }
    @IBAction func radii1Action( _ sender: AnyObject? ) { radiiAction(.Covalent) }
    @IBAction func radii2Action( _ sender: AnyObject? ) { radiiAction(.Ion) }
    @IBAction func radii3Action( _ sender: AnyObject? ) { radiiAction(.Van_der_Waals) }
    @IBAction func radii4Action( _ sender: AnyObject? ) { radiiAction(.Unit) }
    @IBAction func radii5Action( _ sender: AnyObject? ) { radiiAction(.Ellipsoid) }

    func prepareRadiiView() {

        radiiItem0.text = "Calculated Radii"
        radiiItem0.action = #selector(radii0Action)
        radiiItem1.text = "Covalent Radii"
        radiiItem1.action = #selector(radii1Action)
        //        radiiItem2.text = "Ion Radii"
        //        radiiItem2.action = #selector(radii2Action)
        radiiItem3.text = "Van-der-Waals Radii"
        radiiItem3.action = #selector(radii3Action)
        radiiItem4.text = "Unit Radii"
        radiiItem4.action = #selector(radii4Action)
        radiiItem5.text = "Displacement (Thermal)"
        radiiItem5.action = #selector(radii5Action)

        for view in radiiView.arrangedSubviews {
            radiiView.removeArrangedSubview(view)
        }

        radiiView.addArrangedSubview( lineView() )
        radiiView.addArrangedSubview( spaceView(lineSpace) )
        radiiView.addArrangedSubview( titleView("Radii"))
        radiiView.addArrangedSubview( radiiItem0 )
        radiiView.addArrangedSubview( radiiItem1 )
        radiiView.addArrangedSubview( radiiItem3 )
        radiiView.addArrangedSubview( radiiItem4 )
        if crystal?.info.aniso.count ?? 0 > 0 {
            radiiView.addArrangedSubview(radiiItem5)
        }
        radiiView.addArrangedSubview(spaceView(12))
    }


    func updateRadiiView() {
        let radiiMode = crystal?.radiiType ?? nil
        //        let items = [ radiiItem0, radiiItem1, radiiItem2, radiiItem3, radiiItem4, radiiItem5 ]
        let items = [ radiiItem0, radiiItem1, radiiItem3, radiiItem4, radiiItem5 ]
        for item in items {
            item?.selected = false
        }
        if let radiiMode = radiiMode {
            switch radiiMode {
            case .Calculated:
                radiiItem0.selected = true
            case .Covalent:
                radiiItem1.selected = true
                //            case .Ion:
            //                radiiItem2.selected = true
            case .Van_der_Waals:
                radiiItem3.selected = true
            case .Unit:
                radiiItem4.selected = true
            case .Ellipsoid:
                radiiItem5.selected = true
            default:
                break
            }
        }
    }
}
