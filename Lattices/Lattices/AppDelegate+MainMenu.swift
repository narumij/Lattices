//
//  AppDelegate+MainMenu.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    @IBAction func showSceneMenu( _ sender : AnyObject? ) {

        NotificationCenter.default.post(name: latticesMenuWillAppear, object: nil)

        menuWindow = UIWindow( frame: SharedAppDelegate().window!.frame )
        menuWindow.windowLevel = UIWindowLevelNormal

        menuViewController = UIStoryboard(name: kMainStoryboardName, bundle: nil)
            .instantiateViewController(withIdentifier: "hambergerMenuViewController") as! MenuViewController
        menuViewController.document = currentDocument
        menuWindow.rootViewController = menuViewController

        let originalFrame = menuWindow.frame
        var newFrame = menuWindow.frame
        newFrame.origin.x = newFrame.origin.x + newFrame.size.width
        menuWindow.frame = newFrame
        debugPrint("frame \(originalFrame)")

        menuWindow.makeKeyAndVisible()

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: UIViewAnimationOptions(),
                       animations: {
                        self.menuWindow.frame = originalFrame
            }, completion: nil)
    }

    @IBAction func dismissHambergerMenu( _ sender : AnyObject? ) {

        NotificationCenter.default.post(name: latticesMenuWillDisappear, object: nil)

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: UIViewAnimationOptions(),
                       animations:
            {
                [weak self] in
                self?.menuWindow.resignKey()
                var newFrame = self?.menuWindow.frame ?? CGRect.zero
                newFrame.origin.x = newFrame.origin.x + newFrame.size.width
                self?.menuWindow.frame = newFrame

        }) { [weak self] (finished: Bool) in
            _ = self?.menuWindow.subviews.map{ $0.removeFromSuperview() }
            self?.menuWindow = nil
            self?.menuViewController = nil
        }
        //        (window?.rootViewController as! UINavigationController).navigationBarHidden = false
    }

}
