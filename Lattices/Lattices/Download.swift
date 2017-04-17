//
//  Download.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/18.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

class DownloadManager : NSObject, URLSessionDownloadDelegate {

    static let shared = DownloadManager()

    override private init() {
        super.init()
        session = URLSession( configuration: URLSessionConfiguration.default,
                              delegate: self,
                              delegateQueue: OperationQueue.main )
    }

    var session: URLSession = URLSession.shared
    var items: [URLSessionDownloadTask:DownloadItem] = [:]

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        let item = items[downloadTask]
        if let filename = downloadTask.response?.suggestedFilename {
            item?.filename = filename
        }

        if (item?.filename as NSString?)?.pathExtension != "cif" {
            let c1 = (item?.filename as NSString?)?.deletingPathExtension
            if (c1 as NSString?)?.pathExtension != "cif" {
                item?.filename = (c1 as NSString?)!.appendingPathExtension("cif")!
            }
        }
        if totalBytesExpectedToWrite < 0 {
            item?.message = "Download \(totalBytesWritten) bytes"
        }
        else {
            let perce = NSString(format: "%3.0f", (Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)) * 100.0)
            item?.message = "Download \(totalBytesWritten) bytes (\(perce)%)"
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let item = items[downloadTask]
        item?.message = "Download Finished"
        item?.completionHandler(downloadedURL: location, response: downloadTask.response, error: nil)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    }

}

class DownloadItem {
    let url: URL
    var filename: String
    var message = "" {
        didSet {
            messageDidSetHandler?(self)
        }
    }
    var messageDidSetHandler: ((DownloadItem)->Void)? = nil
    var downloadTask: URLSessionDownloadTask? = nil
    var finished = false

    init( _ url: URL ) {
        self.url = url
        filename = url.lastPathComponent
    }

    deinit {
        debugPrint("deinit")
    }

    func resume() {
        messageDidSetHandler = {(_)in
            debugPrint("item(\(self.filename)) \"\(self.message)\"")
        }
        let session = DownloadManager.shared.session
        downloadTask = session.downloadTask(with: url)
        DownloadManager.shared.items[downloadTask!] = self
        downloadTask?.resume()
    }

    func completionHandler( downloadedURL: URL?, response: URLResponse?, error: Error?) -> Void {

        var alertTitle = ""
        var alertMessage = ""
        func showAlert() {
            #if false
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.myshow(animated: true, completion: nil)
            #endif
        }

        if let error = error {
            debugPrint(error.localizedDescription)
            return
        }

        message = "File Copy"

        debugPrint("finish download \(String(describing: downloadedURL)) \(String(describing: response?.suggestedFilename))")
        assert( try! Data(contentsOf: downloadedURL!).count > 0 )


        let saveURL = temporaryFileURL(filename)
        var flag = false

        do {
            if FileManager.default.fileExists(atPath: saveURL.path) {
                try FileManager.default.removeItem(at: saveURL)
            }
            try FileManager.default.moveItem(at: downloadedURL!, to: saveURL)
        }
        catch {
            message = "Failure"
            alertTitle = "File Copy Error"
            alertMessage = "Somthing wrong."
            showAlert()
            flag = true
        }

        if flag == false { debugPrint("save ok") }
        if flag { return }

        message = "File Check"

        do {
            try CIFParser().parse(saveURL.path)
        }
        catch {
            message = "Failure"
            alertTitle = "Parse Error"
            alertMessage = "File test fail.\n"+"Probably \(filename) is not CIF."
            showAlert()
            flag = true
        }

        if flag { return }

        debugPrint("parse ok")

        #if true

            guard let documentBrowserController = documentBrowserController() else {
                return
            }

            OperationQueue.main.addOperation({
                documentBrowserController.copyDocument( of: saveURL, andOpen:false, andRemove: false )
                if flag == false {
                    alertTitle = "Succeed"
                    alertMessage = "\(self.filename) is now available."
                    showAlert()
                    self.message = "Succeed"
                }
//                documentBrowserController.openDocumentAtURL( saveURL, copyBeforeOpening: false )
            })
        #endif
        DownloadManager.shared.items.removeValue(forKey: downloadTask!)
    }
    
}


