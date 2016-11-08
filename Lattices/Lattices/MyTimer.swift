//
//  MyTimer.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/17.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class MyTimer {
    
    let noteNames: [NSNotification.Name] = [
        .UIApplicationDidBecomeActive,
        .UIApplicationDidEnterBackground,
        .UIApplicationWillEnterForeground,
        .UIApplicationWillResignActive,
        .UIApplicationWillTerminate
    ]

    var runLoop: RunLoop?
    var valid: Bool = false
    var timer: Timer?
    var proc: (Timer)->Void
    var timeInterval: CFAbsoluteTime

    init( timeInterval i: CFAbsoluteTime, proc p: @escaping (Timer)->Void ) {
        proc = p
        timeInterval = i
        _ = noteNames.map{
            NotificationCenter
                .default
            .addObserver(self,
                         selector: #selector(recieve),
                         name: $0,
                         object: nil)
        }
        start()
    }

    deinit {
        _ = noteNames.map{
            NotificationCenter
                .default
                .removeObserver(self, name: $0, object: nil)
        }
    }

    func start() {
        if timer == nil {
//            debugPrint("my timer start")
            timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(fire),
                                         userInfo: nil, repeats: true)
            valid = true
        }
    }

    func stop() {
        if timer != nil {
//            debugPrint("my timer stop")
            timer?.invalidate()
            timer = nil
            valid = false
        }
    }

    @objc func fire() {
//        debugPrint("my timer fire!")
        proc(timer!)
    }

    @objc func recieve( note: Notification ) {
        if note.name == .UIApplicationDidBecomeActive {
            start()
        }
        if note.name == .UIApplicationDidEnterBackground {
            stop()
        }
        if note.name == .UIApplicationWillEnterForeground {
            start()
        }
        if note.name == .UIApplicationWillResignActive {
            stop()
        }
        if note.name == .UIApplicationWillTerminate {
            stop()
        }
    }

}





