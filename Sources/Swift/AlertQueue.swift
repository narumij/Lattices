//
//  AlertQueue.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/21.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class AlertQueue: NSObject {

    static let StandardQueue: AlertQueue = AlertQueue()

    fileprivate override init() {
    }

    func showNext() {
        if queue.count == 0 { return }
        inc()
        objc_sync_enter(queue)
        let alert = queue.first
        queue.removeFirst()
        objc_sync_exit(queue)

        alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            self?.showNext()
            self?.dec()
        }))

        OperationQueue.main
            .addOperation({
                debugPrint("show alert")
                UIApplication.shared.keyWindow?.rootViewController?
                    .present( alert!, animated: true, completion: nil )
            })
    }

    var count = 0

    func inc() {
        count = count + 1
    }

    func dec() {
        count = count - 1
    }

    var queue : [UIAlertController] = []

    func add( _ alert: UIAlertController ) {
        debugPrint("add alert \(self)")
        objc_sync_enter(queue)
        queue.append(alert)
        objc_sync_exit(queue)
        if count == 0 {
            showNext()
        }
    }

}

