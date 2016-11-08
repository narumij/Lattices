//
//  DownloadManagerViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/18.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class DownloadManagerViewController: UINavigationController {

    static let shared: DownloadManagerViewController = DownloadManagerViewController(nibName: "DownloadManagerViewController", bundle: nil)

    func show() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        modalPresentationStyle = .formSheet
        rootViewController?.present(self, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        pushViewController(DownloadManagerTableViewController.shared, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
