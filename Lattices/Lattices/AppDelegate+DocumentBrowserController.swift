//
//  AppDelegate+DocumentBrowserController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/17.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

#if false
extension AppDelegate {
    func documentBrowserController() -> DocumentBrowserController? {
        guard let navigation = window?.rootViewController as? UINavigationController else {
            return nil
        }
        guard let documentBrowserController = navigation.viewControllers.first as? DocumentBrowserController else {
            return nil
        }
        return documentBrowserController
    }
}
#endif

func documentBrowserController() -> DocumentBrowserController? {
    guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
        return nil
    }
    guard let window = appDelegate.window else {
        return nil
    }
    guard let navigation = window.rootViewController as? UINavigationController else {
        return nil
    }
    return navigation.viewControllers.first as? DocumentBrowserController
}

