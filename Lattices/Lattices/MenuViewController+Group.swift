//
//  MenuViewControllerGroup.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension MenuViewController {

    @IBAction func groupAction( _ sender: AnyObject? ) {
        if crystal?.bondingRangeMode != .Grouping {
            crystal?.bondingRangeMode = .Grouping
        }
        let tag : Int = (sender as? UIButton)?.tag ?? -1
        if let primeAtomBondGroup = crystal?.prime.bondGroups {
            _ = primeAtomBondGroup.filter({ $0.index == tag }).map{
                $0.publFlag = !$0.publFlag
            }
        }
        if tag == -1 {
//            debugPrint("hogehoge!")
            let primeAtomBondGroup : [PrimeAtomBondGroup_t] = crystal?.prime.bondGroups ?? []
            let publCount : Int = ( primeAtomBondGroup.map({ $0.publFlag ? 1 as Int : 0 as Int }).reduce(0 as Int){ $0 + $1 } )
            let publFlag : Bool = ( primeAtomBondGroup.count / 2 ) < publCount
            _ = primeAtomBondGroup.map( { $0.publFlag = !publFlag } )
        }
        crystal?.updateBondingRangeMode()
        //        updateGroupView()
        updateUI()
    }

    func prepareGroups() {
        #if true
            groupItemViews = []
            if let primeAtomGroups = crystal?.prime.bondGroups {
                if primeAtomGroups.count > 0 {
                    groups.axis = .vertical
                    mainStackView.addArrangedSubview(groups)

                    groups.addArrangedSubview( lineView() )
                    groups.addArrangedSubview( spaceView(lineSpace) )
                    groups.addArrangedSubview( titleView("Group Publication") )
                    let allItem = itemView( "All", action: #selector(groupAction), tag: -1 )
                    groups.addArrangedSubview( allItem )
                    groupItemViews.append( allItem )

                    func th(_ i: Int ) -> String {
                        switch i {
                        case 1:
                            return "1st"
                        case 2:
                            return "2nd"
                        case 3:
                            return "3rd"
                        default:
                            return "\(i)th"
                        }
                    }

                    for group in primeAtomGroups {

                        let index : Int = group.index + 1

                        let allSymbols = group.atoms.map{$0.site.atomicSymbol}

                        let symbolSum: [(AtomicSymbol,Int)] = nub( allSymbols ).map({
                            (symbol) in
                            let count = allSymbols.filter({$0 == symbol}).count
                            return (symbol,count)
                        }).sorted(by: {
                            if $0.1 != $1.1 {
                                return $0.1 > $1.1
                            }
                            return $0.0 < $1.0
                        })

                        var sumText = symbolSum.map({
                            "\($0.0)\($0.1 < 2 ? "" : "\($0.1)")"
                        }).joined(separator:" ")

                        if sumText.length > 13 {
                            sumText = symbolSum.map({"\($0.0)"}).joined(separator: ",")
                        }
                        if group.atoms.count == 1 {
                            let atom: PrimeAtom_t = group.atoms.first!
                            sumText = "'\(atom.site.label)' - \(th(atom.symop.index))"
                        }
                        let title : String = "\(index). \(sumText)"
                        let anItemView = itemView( title, action: #selector(groupAction), tag: group.index )
                        anItemView.tag = group.index
                        groups.addArrangedSubview( anItemView )
                        groupItemViews.append( anItemView )
                    }
                    
                    symmetry.addArrangedSubview(spaceView(12))
                }
            }
        #endif
    }

    func clearGroups() {
        groups.arrangedSubviews.forEach{
            groups.removeArrangedSubview($0)
        }
    }

    func updateGroupView() {

        if (crystal?.prime.bondGroups.count ?? 0) < 2 || crystal?.bondingRangeMode != .Grouping {
            clearGroups()
            groups.isHidden = true
        }
        else {
            groups.isHidden = false
            if groups.arrangedSubviews.isEmpty {
                prepareGroups()
            }
        }
        
        _ = groupItemViews.map{
            let index : Int = $0.tag
            if index == -1 {
                let primeAtomGroups = crystal?.prime.bondGroups ?? []
                let publCount : Int = ( primeAtomGroups.map({ $0.publFlag ? 1 as Int : 0 as Int }).reduce(0 as Int){ $0 + $1 } )
                $0.selected = primeAtomGroups.count == publCount
            }
            else {
                $0.selected = crystal?.prime.bondGroups[index].publFlag ?? false
            }
        }
        
    }

}
