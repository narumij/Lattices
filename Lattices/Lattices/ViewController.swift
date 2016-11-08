//
//  ViewController.swift
//  SwiftCrystaliOS
//
//  Created by Jun Narumi on 2016/06/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class ViewController: UIViewController {

    var document: Document?
    var documentURL: URL? {
        didSet {
            guard let url = documentURL else { return }

            document = Document(fileURL: url)

            do {
                var displayName: AnyObject?
                try (url as NSURL).getPromisedItemResourceValue(&displayName, forKey: URLResourceKey.localizedNameKey)
                title = displayName as? String

                debugPrint("title = \(title)")
            }
            catch {
                // Ignore a failure here. We'll just keep the old display name.
            }
        }
    }

    var isLocalDocument: Bool = false

    var timer: Timer?
    var active = false
    var cameraController : CameraController?

    @IBOutlet weak var LoadingSign : UIActivityIndicatorView!
    @IBOutlet weak var workProgress : UIProgressView?
    @IBOutlet weak var progressKindView : UILabel?
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var menuButton : UIButton!
    @IBOutlet weak var sceneViewWidth: NSLayoutConstraint?
    @IBOutlet weak var sceneViewHeight: NSLayoutConstraint?
    @IBOutlet weak var axisView: SCNView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        timer = Timer(timeInterval: 1.0/60.0,
                      target: TimerAdapter({[weak self] in self?.momentum()}),
                      selector: #selector(TimerAdapter.fire),
                      userInfo: nil,
                      repeats: true)

        RunLoop.current.add( timer!, forMode: RunLoopMode.commonModes )

        startProgressObserving()

        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(menuNotify),
                       name: latticesMenuWillAppear,
                       object: nil)

        nc.addObserver(self,
                       selector: #selector(menuNotify),
                       name: latticesMenuWillDisappear,
                       object: nil)

        nc.addObserver(self,
                       selector: #selector(updateCenter),
                       name: SwiftCrystal.didChangeBondingRangeMode,
                       object: nil)

    }

    deinit {
        debugPrint("deinit \(self)")
        timer?.invalidate()

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        sceneView.scene = nil
        SCNTransaction.commit()

        stopProgressObserving()

        let nc = NotificationCenter.default
        nc.removeObserver( self,
                           name: latticesMenuWillAppear,
                           object: nil )

        nc.removeObserver( self,
                           name: latticesMenuWillDisappear,
                           object: nil )

        nc.removeObserver( self,
                           name: SwiftCrystal.didChangeBondingRangeMode,
                           object: nil )
    }

    @objc func menuNotify( _ note: Notification ) {
        switch note.name {
        case latticesMenuWillAppear:
            menuButton.isHidden = true
            backButton.isEnabled = false
        default:
            menuButton.isHidden = false
            backButton.isEnabled = true
        }
    }

    func updateScene() {
        assert(Thread.isMainThread)

        guard let sceneView = sceneView else {
            return
        }
        guard let document = document else {
            return
        }

        axisView.scene = document.crystal.axisSceneController.scene
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let screenBounds = UIScreen.main.bounds
            let longer = max(screenBounds.width,screenBounds.height)
            sceneViewWidth?.constant = longer
            sceneViewHeight?.constant = longer
            debugPrint("size : \(longer)")
        } else {
            sceneViewWidth?.constant = view.bounds.width
            sceneViewHeight?.constant = view.bounds.height
        }

        view.layoutIfNeeded()

        sceneView.pointOfView = document.crystal.camera.cameraNode()
        postProgressKey( .UpdateScene, progress: 1.0 )

        let scene = document.crystal.scene
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        SCNTransaction.completionBlock = {
            self.updateCenter()
        }
        sceneView.scene = scene
        sceneView.scene = scene
        sceneView.pointOfView = document.crystal.camera.cameraNode()
        SCNTransaction.commit()

        if document.crystal.isRadiiUpdated == false {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = Document.initialAnimationDuration
            SCNTransaction.completionBlock = {
                self.updateCenter()
            }
            document.crystal.updateRadii()
            SCNTransaction.commit()
            if Document.initialAnimationDuration > 0.0 {
                document.animationFinishDate = Date(timeIntervalSinceNow: Document.initialAnimationDuration)
            }
        }

        title = document.title()
        cameraController = CameraController(view: sceneView,
                                            crystal: document.crystal)
        LoadingSign.stopAnimating()
        menuButton.isEnabled = true
        sceneView.isHidden = false
        postProgressKey( .finish, progress:0.0 )
        debugPrint( "update scene complete." )

        document.updateChangeCount(.done)
    }

    func updateCenter() {
        if let sphere = document?.crystal.camera.sphere {
            let area : CGFloat = UI_USER_INTERFACE_IDIOM() == .phone ? 0.3333 : 0.2
            let border = FloatType(min(sceneView.bounds.width,sceneView.bounds.height) * 0.5 * area)
            let projectCenter = sceneView.projectPoint(sphere.center)
            let viewCenter = sceneView.bounds.center
            let d = distance(Vector3(projectCenter).xy,Vector2(FloatType(viewCenter.x),FloatType(viewCenter.y)))
//            let d = distance(Vector3(projectCenter).xy,Vector2(FloatType(viewCenter.x),0))
//            debugPrint("center distance \(d) : \(border)")
            if d > border {
                document?.crystal.updateCenterWith(sceneView)
            }
            else {
                document?.crystal.recoverCenter()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        navigationItem.leftBarButtonItem?.title = "Back"
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        sceneView.stop(nil)
        axisView.stop(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        if UIDevice.current.userInterfaceIdiom == .phone {
            sceneViewWidth?.constant = size.width
            sceneViewHeight?.constant = size.height
            sceneView.layoutIfNeeded()
            sceneView.setNeedsDisplay()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        document = Document(fileURL: documentURL!)
        SharedAppDelegate().currentDocument = document
        SharedAppDelegate().workProgressController.prepareForFileLoad()
        postProgressKey( .Start, progress: 0.1)

        #if false
            if document?.documentState.contains(.progressAvailable) == true {
                workProgress?.observedProgress = document?.progress
            }
        #endif

        document?.open(completionHandler:{(flag)in
            self.document?.loadSuccess = flag
            self.updateScene()
            #if false
                self.workProgress?.isHidden = true
            #endif

            if self.isLocalDocument {
                return
            }

            guard let documentBrowserController = documentBrowserController() else {
                return
            }
            documentBrowserController.documentWasOpenedSuccessfullyAtURL(self.document!.fileURL)
        })
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SCNTransaction.flush()
        postProgressKey( .Start, progress: 0.4)
        active = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        active = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        documentBrowserController()?.closeDocument()
        document?.close(completionHandler: {(_)in })
        SharedAppDelegate().currentDocument = nil
    }

    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            stopMomentum()
        }
    }

    @IBAction func unwindToTop( _ sender: UIStoryboardSegue ) {
        debugPrint("unwindToTop \(self)")
    }

    // MARK: -

    @IBOutlet weak var singlePanGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var singleTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var orthTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var resetTapGestureRecognizer: UITapGestureRecognizer!
    var lastPan = CGPoint.zero
    var hasRotateXYMomentum = false {
        didSet {
            document?.updateChangeCount(.done)
        }
    }
    var rotateXYVelocity = Vector2Zero
    var hasTranslateMomentum = false {
        didSet {
            document?.updateChangeCount(.done)
        }
    }
    var translateVelocity = Vector2Zero
    var cameraLock = NSLock()
    var tapGestureDisableTimeOut : CFAbsoluteTime = 0.0
    var lastDoublePan = CGPoint.zero
    var isActiveDoublePan = false
    var lastDoubleTapGestureTouches = 0
    var lastRotate : CGFloat = 0

    #if false
    @objc func cameraDirectionNotification( _ note: Notification? ) {
        if let info : [AnyHashable: Any] = (note as NSNotification?)?.userInfo {
            debugPrint("note : \(info)")
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            cameraLock.syncBlock {
                [weak self] in
                self?.stopMomentum()
            }
            SCNTransaction.commit()
        }
    }
    #endif
}













