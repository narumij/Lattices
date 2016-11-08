//
//  RadiiSetContainerViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/10.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class RadiiSetContainerViewController: UIViewController {

    @IBOutlet weak var button : UIButton!

    func updateUI() {
        button.setTitle( SharedAppDelegate().currentDocument?.crystal.radiiFileName ?? "-", forState: UIControlState.Normal )
    }

    override func viewWillAppear(animated: Bool) {
        updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
