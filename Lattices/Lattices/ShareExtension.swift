//
//  ShareExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/19.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

fileprivate var flag = false

let lockQueue = DispatchQueue( label: "jp.zenithgear.polling.lock" )

func insertItemOfShareExtension() {

    if FileManager().ubiquityIdentityToken == nil {
        return
    }

    lockQueue.sync {
        processTextList()
        processURLList()
    }
}

extension UIAlertController {
    func myshow( animated flag: Bool, completion: (() -> Void)? ) {
        AlertQueue.StandardQueue.add(self)
    }
}

private func processURLList() {
    let userDefaults = UserDefaults(suiteName: "group.jp.zenithgear.Lattices")
    let array = (userDefaults?.object(forKey: "urlList") ?? []) as! [[String:String]]
//    debugPrint("share extensnion \(array)")

    if array.count > 0 {
        #if true
            DownloadManagerViewController.shared.show()
        #else
            let alert = UIAlertController(title: "Recieve URL",
                                          message: "Downloading \(array.count) file\( array.count == 1 ? "" : "s" ).",
                                          preferredStyle: .alert)
            alert.myshow(animated: true, completion: nil)
        #endif
    }

//    debugPrint("process URL list (\(array.count))")

    for anItem in array {

        #if true
            if let urlString = anItem["url"] {
                guard let url = URL(string: urlString) else {
                    return
                }

                let item = DownloadItem(url)
                item.resume()
                DownloadManagerTableViewController.shared.reloadData()
            }
        #else
        if let urlString = anItem["url"] {
            let url = URL(string: urlString)

            URLSession.shared
                .downloadTask(with: url!, completionHandler:
                    { (downloadedURL, response, error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        }
                        else {
                            debugPrint("finish download \(downloadedURL) \(response?.suggestedFilename)")

                            var filename = response?.suggestedFilename
                            if filename == nil {
                                filename = url?.lastPathComponent
                            }

                            if let c0 = filename {
                                if (c0 as NSString).pathExtension != "cif" {
                                    let c1 = (c0 as NSString).deletingPathExtension
                                    if (c1 as NSString).pathExtension != "cif" {
                                        filename = (c1 as NSString).appendingPathExtension("cif")
                                    }
                                }
                            }


                            if let filename = filename {
                                let saveURL = temporaryFileURL(filename)
                                var flag = false

                                do {
                                    try FileManager.default.moveItem(at: downloadedURL!, to: saveURL)
                                }
                                catch {
                                    let alert = UIAlertController(title: "Error", message: "Something wrong.", preferredStyle: .alert)
                                    alert.myshow(animated: true, completion: nil)
                                    flag = true
                                }

                                if flag == false { debugPrint("save ok") }
                                if flag { return }

                                do {
                                    try CIFParser().parse(saveURL.path)
                                }
                                catch {
                                    let alert = UIAlertController(title: "Parse Error", message: "File test fail.\n"+"Probably \(filename) is not CIF.", preferredStyle: .alert)
                                    alert.myshow(animated: true, completion: nil)
                                    flag = true
                                }

                                if flag { return }

                                debugPrint("parse ok")

                                #if false
                                OperationQueue.main
                                    .addOperation({
                                        NotificationCenter.default
                                            .post( name: Notification.Name(rawValue: AppDelegateDidUpdateDocumentsNotification), object: nil )
                                    })
                                #endif

                                #if true

                                    guard let documentBrowserController = documentBrowserController() else {
                                        return
                                    }

                                    OperationQueue.main.addOperation({
                                        documentBrowserController.copyDocument( of: saveURL, andOpen:false )
                                        if flag == false {
                                            let alert = UIAlertController(title: "Succeed", message: "\(filename) is now available.", preferredStyle: .alert)
                                            alert.myshow(animated: true, completion: nil)
                                        }
//                                        documentBrowserController.openDocumentAtURL( saveURL, copyBeforeOpening: false )
                                    })

                                #endif
                            }
                        }
                }).resume()

        }
        #endif
    }

    if array.count > 0 {
        userDefaults?.removeObject(forKey: "urlList")
    }
}

private func processTextList() {
//    debugPrint("process text list (pending)")
}

