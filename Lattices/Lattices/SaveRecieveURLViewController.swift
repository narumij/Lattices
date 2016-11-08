//
//  SaveRecieveURLViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/12.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class SaveRecieveURLViewController: UIViewController {

    deinit {
        debugPrint("deinit \(self)")
    }

    var crystal : SwiftCrystal?
    var url: URL?
    var image: UIImage?

    func labelText() -> String {
        if let path = url?.path {
            return (path as NSString).lastPathComponent
        }
        return "n/a"
    }

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var imageWidth : NSLayoutConstraint?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var indicator: UIActivityIndicatorView?

    func loadURL() {
        crystal = SwiftCrystal()
        crystal?.updateRadii()
        crystal?.bondingMode = .Off
        do {
            try crystal?.read( url: url!, ofType: "" )
        } catch {
        }
        image = crystal?.image(imageView!.frame.size)
    }

    func prepare() {
        OperationQueue().addOperation{
            [weak self] in
            self?.loadURL()
            OperationQueue.main.addOperation{
                [weak self] in
                self?.updateUI()
            }
        }
    }

    func updateUI() {
        let screenSize = UIScreen.main.bounds.size
        let width = min( screenSize.width, screenSize.height ) - 60.0
        imageWidth?.constant = width
        label?.text = labelText()
        if let image = image {
            imageView?.contentMode = UIViewContentMode.scaleAspectFit
            imageView?.image = image
            indicator?.stopAnimating()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        prepare()
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
