//
//  TableViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/08.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit
import SceneKit

class TableViewController: UITableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default
            .addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: AppDelegateDidFinishOpenURLNotification), object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: AppDelegateDidUpdateDocumentsNotification), object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: Document.DidSaveThumnailNotification), object: nil)
    }

    deinit {
        debugPrint("deinit \(self)")
        NotificationCenter.default
            .removeObserver(self, name: NSNotification.Name(rawValue: AppDelegateDidFinishOpenURLNotification), object: nil)
        NotificationCenter.default
            .removeObserver(self, name: NSNotification.Name(rawValue: AppDelegateDidUpdateDocumentsNotification), object: nil)
        NotificationCenter.default
            .removeObserver(self, name: NSNotification.Name(rawValue: Document.DidSaveThumnailNotification), object: nil)
    }

    @objc func reload( _ note: Notification ) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        title = "Lattices"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
        tableView.reloadData()
//        debugPrint("\(UIApplication.sharedApplication().keyWindow?.backgroundColor)")
//        assert(UIApplication.sharedApplication().keyWindow != nil)
//        UIApplication.sharedApplication().keyWindow?.backgroundColor = UIColor.whiteColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loadFiles().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let file = loadFiles()[indexPath[1]]
        cell.textLabel?.text = (file as NSString).deletingPathExtension
        cell.imageView?.image = Document.thumbnail( name: file )
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source

            #if false
                deleteFile(loadFiles()[indexPath.indexAtPosition(1)])
            #else
                let cifURL = fileURL(loadFiles()[indexPath[1]])
                Document.removeThumbnail(cifURL)
                Document.removeDataFile(cifURL)
                Document.removeCIFFile(cifURL)
            #endif
            tableView.deleteRows( at: [indexPath], with: .fade )

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func urlForIndexPath(indexPath: IndexPath) -> URL {
        let file = loadFiles()[indexPath[1]]
        return fileURL(file)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = urlForIndexPath(indexPath: indexPath)
        openDocumentAtURL(url)
    }

    func openDocumentAtURL(_ url: URL) {
        // Push a view controller which will manage editing the document.
        let controller = storyboard!.instantiateViewController(withIdentifier: "SceneViewController") as! ViewController
        controller.documentURL = url
        controller.isLocalDocument = true
        show(controller, sender: self)
    }

    @IBAction func gotoSettingApp(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
}


