//
//  ViewController+HandleProgress.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

extension ViewController {

    func startProgressObserving() {
        let nc = NotificationCenter.default
        nc.addObserver( self,
                        selector: #selector( progressStartNotification ),
                        name: NSNotification.Name(rawValue: WorkProgressController.WillStartProgressNotification),
                        object: nil )

        nc.addObserver( self,
                        selector: #selector( progressChangeNotification ),
                        name: NSNotification.Name(rawValue: WorkProgressController.DidChangeProgressNotification),
                        object: nil )

        nc.addObserver( self,
                        selector: #selector( progressFinishNotification ),
                        name: NSNotification.Name(rawValue: WorkProgressController.DidFinishProgressNotification),
                        object: nil )
    }

    func stopProgressObserving() {
        let nc = NotificationCenter.default
        nc
            .removeObserver( self,
                             name: NSNotification.Name(rawValue: WorkProgressController.WillStartProgressNotification),
                             object: nil )

        nc
            .removeObserver( self,
                             name: NSNotification.Name(rawValue: WorkProgressController.DidChangeProgressNotification),
                             object: nil )

        nc
            .removeObserver( self,
                             name: NSNotification.Name(rawValue: WorkProgressController.DidFinishProgressNotification),
                             object: nil )
    }

    @objc func progressStartNotification( _ note: Notification? ) {
        assert(Thread.isMainThread)
        menuButton.isEnabled = false
        workProgress?.isHidden = false
        workProgress?.progress = 0.0
        UIView.animate( withDuration: 0.5, animations: { self.workProgress?.alpha = 1.0 } )
    }

    @objc func progressChangeNotification( _ note: Notification? ) {
        if let progress = SharedAppDelegate().workProgressController.progress {
            workProgress?.setProgress( Float(progress.fractionCompleted), animated: true )
            #if true
                if let child: Progress = SharedAppDelegate().workProgressController.currentProgress {
                    progressKindView?.text = child.kind.map { $0.rawValue }
                }
            #endif
        }
    }

    @objc func progressFinishNotification( _ note: Notification? ) {
        workProgress?.setProgress( 1.0, animated: true )
        progressKindView?.text = "Acomplished"
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: [],
                       animations: {
                        self.workProgress?.alpha = 0.0
                        self.progressKindView?.alpha = 0.0 },
                       completion: { _ in
                        self.workProgress?.isHidden = true
                        self.progressKindView?.isHidden = true
                        SharedAppDelegate().workProgressController.cleanUp() } )
    }

}

