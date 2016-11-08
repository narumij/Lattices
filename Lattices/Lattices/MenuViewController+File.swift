//
//  MenuViewController+File.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/19.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension MenuViewController {

    func updateFileMenus() {
    }

}

extension MenuViewController {

    @IBAction func rawText( sender: AnyObject? ) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "SourceView") as! SourceViewController
        controller.document = document
        let nav = UINavigationController(rootViewController: controller)
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        nav.modalPresentationStyle = .formSheet
        rootViewController?.present( nav, animated: true, completion: nil)
    }

    func prepareFileMenus() {

        func ____(_ stackView: UIStackView,_ items: inout [ItemView] ) {

            let filename = document?.fileURL.lastPathComponent
            stackView.axis = .vertical
            mainStackView.addArrangedSubview( stackView )
            stackView.addArrangedSubview( lineView() )
            stackView.addArrangedSubview( spaceView(lineSpace) )
            stackView.addArrangedSubview( titleView(filename!) )

            let item = itemView( "raw text", action: #selector(rawText) )
            stackView.addArrangedSubview(item)
            items.append(item)

            stackView.addArrangedSubview( spaceView(12) )

        }

        ____( fileMenu, &fileMenuItems )
    }
    
}

