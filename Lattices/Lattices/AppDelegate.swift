//
//  AppDelegate.swift
//  SwiftCrystaliOS
//
//  Created by Jun Narumi on 2016/06/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit
import SceneKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var currentDocument: Document?
    var workProgressController = WorkProgressController()

    var defaultObserver : NSObjectProtocol?

    var myTimer: MyTimer?

    override init() {
        super.init()

        defaultObserver =
            NotificationCenter
            .default
            .addObserver(forName: UserDefaults.didChangeCloudAccountsNotification,
                         object: nil,
                         queue: OperationQueue.main ) { _ in
                            debugPrint("user default updates.")
                            insertItemOfShareExtension() }

    }

    deinit {
        if let observer = defaultObserver {
            NotificationCenter.default.removeObserver(observer)
            defaultObserver = nil
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)

        if UIDevice.current.userInterfaceIdiom == .pad {
//            CameraInitial.stdFov *= (1024.0/768.0)
//            debugPrint("CameraInitial.stdFov = \(CameraInitial.stdFov)")
            CameraInitial.stdScaleRate *= (1024.0/768.0)
        }

        touchDummy()
        registerDefaults()
//        sampleCopyWhenFirstLaunch()
        reflectSettingsBundle()
//        insertItemOfShareExtension()

        #if true
        myTimer = MyTimer(timeInterval: 3.0) { (_) in
            insertItemOfShareExtension()
        }
        #endif

        #if false
            #if false
                let fileManager = NSFileManager.defaultManager()
                let currentiCloudToken = fileManager.ubiquityIdentityToken
                debugPrint(currentiCloudToken)

                if currentiCloudToken != nil {
                    let newTokenData =
                        NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken!)
                    NSUserDefaults.standardUserDefaults().setObject(newTokenData, forKey: "com.apple.MyAppName.UbiquityIdentityToken")
                } else {
                    NSUserDefaults.standardUserDefaults()
                }

                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(iCloudAccountAvailabilityChanged), name: NSUbiquityIdentityDidChangeNotification, object: nil)

                let firstLaunchWithiCloudAvailable = true

                if currentiCloudToken != nil && firstLaunchWithiCloudAvailable {
                    let alert = UIAlertView(title: "Choose Storage Option",
                                            message: "Should documents be stored in iCloud available on all your devices?",
                                            delegate: nil,
                                            cancelButtonTitle: "Local Only",
                                            otherButtonTitles: "Use iCloud" )
                    alert.show()
                }
            #else
                let alertController = UIAlertController(title: "Choose Storage Option", message: "Should documents be stored in iCloud available on all your devices?", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Local Only", style: UIAlertActionStyle.Cancel, handler: {_ in }))
                alertController.addAction(UIAlertAction(title: "Use iCloud", style: UIAlertActionStyle.Default, handler: {_ in }))
                window?.rootViewController?.presentViewController(alertController, animated: true, completion: { _ in })
            #endif
        #endif

        return true
    }

    #if false
    func iCloudAccountAvailabilityChanged(note:NSNotification?) {
        debugPrint(note)
    }

    var myContainer: NSURL?

    func getURL() {
        dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                        {
                            self.myContainer = NSFileManager
                                .defaultManager()
                                .URLForUbiquityContainerIdentifier(nil)

                            if self.myContainer != nil {
                                // Your app can write to the iCloud container
                                dispatch_async (dispatch_get_main_queue (), {
                                    // On the main thread, update UI and state as appropriate
                                    });
                            } });
    }
    #endif

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        reflectSettingsBundle()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        SCNTransaction.flush()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        reflectSettingsBundle()
//        insertItemOfShareExtension()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        reflectSettingsBundle()
        insertItemOfShareExtension()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    var navigationController: UINavigationController {
        return window?.rootViewController as! UINavigationController
    }

//    let operationQueue = OperationQueue()

    #if false
    func closeCurrentDocument() {
        #if false
        currentDocument?.crystal.cancelled = true

        if currentDocument?.loadSuccess == true {
            currentDocument?.saveAux()
            currentDocument?.saveThumnail()
        }

        currentDocument?.close(completionHandler: {(_)in})
        currentDocument = nil
        #endif
    }
    #endif

    // MARK: -

//    let appOpenRecieveLockQueue = DispatchQueue(label: "jp.zenithgear.appOpenRecieveLockQueue")
//    let appOpenPresentLockQueue = DispatchQueue(label: "jp.zenithgear.appOpenPresentLockQueue")
//    let presentLock = NSLock()
//    let recieveQueueLock = NSLock()
//    var recieveQueue : [AppOpen] = []
//    var saveRecieveURLWindow : UIWindow!
//    var saveRecieveNavigationController : UINavigationController!

    // MARK: -
    func application( _ app: UIApplication,
                      open url: URL,
                      options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        debugPrint("")
        debugPrint("application")
        debugPrint("open: \(url)")
        debugPrint("options : \(options)")
        debugPrint("")

        #if true
            guard let shouldOpenInPlace = options[UIApplicationOpenURLOptionsKey.openInPlace] as? Bool else {
                return false
            }

            guard let navigation = window?.rootViewController as? UINavigationController else {
                return false
            }

            guard let documentBrowserController = navigation.viewControllers.first as? DocumentBrowserController else {
                return false
            }

            documentBrowserController.openDocumentAtURL(url, copyBeforeOpening: !shouldOpenInPlace)
//            documentBrowserController.copyDocument( of: url, andOpen: true )
            return true
        #else
            enqueueURL(MakeAppOpen(url:url,options:options))
            return true
        #endif
    }

    // MARK: -

    var menuWindow : UIWindow!
    var menuViewController : MenuViewController!

    // MARK: -

    @IBAction func unwindToRootAction( _ sender : AnyObject? ) {

        if let control = sender as? UIControl {
            control.isEnabled = false
            RunLoop.current.run( until: Date(timeIntervalSinceNow: 0.01) )
        }

        (window?.rootViewController as! UINavigationController).popToRootViewController(animated: true)
        (window?.rootViewController as! UINavigationController).isNavigationBarHidden = false
//        operationQueue.cancelAllOperations()
//        closeCurrentDocument()
    }

    #if false
    func sampleCopyWhenFirstLaunch() {
        let flag = UserDefaults.standard.bool(forKey: AppDelegateDefaultsSampleCopiedKey)
        if flag { return }
        let samples = ["13MEMS.CIF","H2O-Ice.cif","CaCuO2.cif"]
        for name in samples {
            let source = Bundle.main.path(forResource: name, ofType: "")
            let destination : String? = documentsDirectory() != nil ? documentsDirectory()! + "/" + (name as NSString).deletingPathExtension + ".cif" : nil
            if source == nil || destination == nil { continue }
            if FileManager.default.fileExists(atPath: source!) {
                do {
                    try FileManager.default.copyItem(atPath: source!, toPath: destination!)
                } catch {
                }
            }
        }
        UserDefaults.standard.set(true, forKey: AppDelegateDefaultsSampleCopiedKey)
        UserDefaults.standard.synchronize()
    }
    #endif
}


func SharedAppDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

//var CurrentDocument : Document? {
//    return SharedAppDelegate().currentDocument
//}

//var CurrentCrystal : SwiftCrystal? {
//    return CurrentDocument?.crystal
//}







