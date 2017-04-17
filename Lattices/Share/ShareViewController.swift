//
//  ShareViewController.swift
//  Share
//
//  Created by Jun Narumi on 2016/07/19.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

//    @IBOutlet var textView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Save to Lattices";
        let c: UIViewController = self.navigationController!.viewControllers[0]
        c.navigationItem.rightBarButtonItem!.title = "Send"
        debugPrint("\(String(describing: extensionContext?.inputItems))")

    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//    
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
//    }

    override func didSelectPost() {

        let inputItem: NSExtensionItem = self.extensionContext?.inputItems[0] as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider

        // Safari 経由での shareExtension では URL を取得
        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: {
                (item, error) in

                // item に url が入っている
                let itemNSURL: URL = item as! URL

                // 行いたい処理を書く
                self.setUserDefaultToItem(itemNSURL)
            })
        }

        if (itemProvider.hasItemConformingToTypeIdentifier("public.plain-text")) {
            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: {
                (item, error) in

                // 行いたい処理を書く
                // self.contentText に shareExtension のメインテキストエリアで記入したテキスト情報が入るので、
                // テキストを取得するだけであれば、特に追記はありません。
            })
        }
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    fileprivate func setUserDefaultToItem( _ url: URL ) {
        let userDefaults = UserDefaults(suiteName: "group.jp.zenithgear.Lattices")

        let listKey = "urlList"
        let urlKey = "url"

        var urlList: [ [String:String] ] =
            userDefaults?.object(forKey: listKey) as? [ [String:String] ] ?? []

        let itemContainer = [
            "name" : self.contentText!,
            urlKey : url.absoluteString]

        urlList = urlList.filter({ $0[urlKey] != url.absoluteString })
        urlList.append( itemContainer )

        debugPrint("urlList \(urlList)")
        assert( urlList.count > 0)

        userDefaults?.set( urlList, forKey: listKey)
        userDefaults?.synchronize()
    }
}


