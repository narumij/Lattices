//
//  SourceViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/19.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class SourceViewController: UIViewController {

    var document: Document?

    @IBOutlet weak var textView: UITextView!

    @IBAction func dismissAction(_ sender: AnyObject? ) {
        parent?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        title = document?.fileURL.lastPathComponent
        let source = String( data: (document?.rawData)!, encoding: .utf8 )
        textView.text = source
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

