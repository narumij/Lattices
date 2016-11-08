//
//  AppDelegate+HandleURLQueue.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

typealias AppOpen = URL

func MakeAppOpen( url:URL,options:[UIApplicationOpenURLOptionsKey : Any] ) -> AppOpen {
    return url
}

extension AppDelegate {


    func enqueueURL( _ url : URL ) {
        objc_sync_enter(recieveQueue)
        recieveQueue.append(url)
        objc_sync_enter(recieveQueue)
        if recieveQueue.count == 1 {
            presentFirstURL()
        }
    }

    func dequeueURL() -> URL? {
        objc_sync_enter(recieveQueue)
        var url : URL? = nil
        if recieveQueue.count > 0 {
            url = recieveQueue.first
            recieveQueue.removeFirst()
        }
        objc_sync_enter(recieveQueue)
        return url
    }

    func discardURL( _ sender: AnyObject? ) {
        let url = dequeueURL()
        removeInboxItem(url!)
        presentNextURL()
    }

    func saveURL( _ sender: AnyObject? ) {
        let url = dequeueURL()
        _ = saveItem(url!)
        removeInboxItem(url!)
        presentNextURL()
    }

    func createSaveReciveURLController(_ url:URL?) -> SaveRecieveURLViewController {
        let sb = UIStoryboard(name: kMainStoryboardName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: kSaveRecieveURLViewControllerIdentifier) as! SaveRecieveURLViewController
        vc.url = url
        let cancelButton = UIBarButtonItem(title: "Discard",
                                           style: UIBarButtonItemStyle.plain,
                                           target: self,
                                           action: #selector(discardURL))
        let saveButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save,
                                         target: self,
                                         action: #selector(saveURL))
        vc.navigationItem.leftBarButtonItem = cancelButton
        vc.navigationItem.rightBarButtonItem = saveButton
        return vc
    }

    func presentFirstURL() {

        if let url = recieveQueue.first {
            saveRecieveURLWindow = UIWindow( frame: UIScreen.main.bounds )
            saveRecieveURLWindow.windowLevel = UIWindowLevelNormal

            let saveRecieveURLViewController = createSaveReciveURLController(url)
            saveRecieveNavigationController = UINavigationController( rootViewController: saveRecieveURLViewController )
            saveRecieveURLWindow.rootViewController = saveRecieveNavigationController

            let originalFrame = saveRecieveURLWindow.frame
            var newFrame = saveRecieveURLWindow.frame
            newFrame.origin.y = newFrame.origin.y + newFrame.size.height
            saveRecieveURLWindow.frame = newFrame

            debugPrint("frame \(originalFrame)")

            saveRecieveURLWindow.makeKeyAndVisible()
            UIView.animate( withDuration: 0.4,
                            delay: 0.0,
                            options: UIViewAnimationOptions(),
                            animations:
                {
                    self.saveRecieveURLWindow.frame = originalFrame
                },
                            completion: nil )
        }

    }

    func presentNextURL() {

        if let url = recieveQueue.first {
            let saveRecieveURLViewController = createSaveReciveURLController(url)
            saveRecieveNavigationController.pushViewController(saveRecieveURLViewController, animated: true)
        }
        else
        {
            UIView.animate(withDuration: 0.4,
                           delay: 0.0,
                           options: UIViewAnimationOptions(),
                           animations:
                {
                    [weak self] in
                    self?.saveRecieveURLWindow.resignKey()
                    var newFrame = self?.saveRecieveURLWindow.frame ?? CGRect.zero
                    newFrame.origin.y = newFrame.origin.y + newFrame.size.height
                    self?.saveRecieveURLWindow.frame = newFrame
                },
                           completion:
                { [weak self] ( finished: Bool ) in
                    self?.saveRecieveURLWindow = nil
                    self?.saveRecieveNavigationController = nil
                    NotificationCenter.default
                        .post(name: Notification.Name(rawValue: AppDelegateDidFinishOpenURLNotification), object: nil)
                } )
        }
    }

}
