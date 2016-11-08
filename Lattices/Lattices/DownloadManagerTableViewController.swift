//
//  DownloadManagerViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/18.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import UIKit

class DownloadManagerTableViewController: UITableViewController {

    static let shared: DownloadManagerTableViewController = DownloadManagerTableViewController(nibName: "DownloadManagerTableViewController", bundle: nil)

    #if false
    func show() {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        modalPresentationStyle = .formSheet
        rootViewController?.present(self, animated: true, completion: nil)
    }
    #endif

    var manager: DownloadManager {
        return DownloadManager.shared
    }

    func reloadData() {
        tableView.reloadData()
    }

    @objc func hogehoge( sender: UIBarButtonItem ) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

        self.navigationItem.title = "Download Recieved URL"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem: .stop, target: self, action: #selector(hogehoge) )

        let nib = UINib(nibName: "DownloadManagerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DownloadManagerTableViewCell")
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
        return manager.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadManagerTableViewCell", for: indexPath)

        // Configure the cell...

        let idx = indexPath[1]
        let item = manager.items.values.map({$0})[idx]

        cell.textLabel?.text = item.filename
        cell.detailTextLabel?.text = item.message

        let detailFont = cell.detailTextLabel!.font!
        cell.detailTextLabel?.font = UIFont.monospacedDigitSystemFont( ofSize: detailFont.pointSize, weight: UIFontWeightThin )

        item.messageDidSetHandler = {
            (item) in
            cell.textLabel?.text = item.filename
            cell.detailTextLabel?.text = item.message
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
