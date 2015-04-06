//
//  AdminPanelViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/2/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class AdminPanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var personTableView: UITableView!
    var randBios: [(String, Bool)] = UserStore.bios
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personTableView.delegate = self
        personTableView.dataSource = self
        
        personTableView.setEditing(true, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as UITableViewCell
        
        cell.showsReorderControl = true
        
        cell.textLabel?.text = "sex"
        cell.detailTextLabel?.text = "Foraging"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if tableView.cellForRowAtIndexPath(indexPath)!.detailTextLabel?.text == "Foraging" {
            tableView.cellForRowAtIndexPath(indexPath)!.detailTextLabel?.text = "Control"
        }
        else {
            tableView.cellForRowAtIndexPath(indexPath)!.detailTextLabel?.text = "Foraging"
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        println("prepped")
    }
}
