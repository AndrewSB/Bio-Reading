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
    var randBios: [(String, Bool)] = UserStore.bios {
        didSet {
            if personTableView != nil {
                personTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personTableView.delegate = self
        personTableView.dataSource = self
        
        personTableView.setEditing(true, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randBios.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellID") as UITableViewCell
        
        cell.textLabel?.text = randBios[indexPath.row].0
        cell.detailTextLabel?.text = randBios[indexPath.row].1 ? "Foraging" : "Control"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        randBios[indexPath.row].1 = !randBios[indexPath.row].1
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {

        let temp = randBios[sourceIndexPath.row]
        randBios.removeAtIndex(sourceIndexPath.row)
        randBios.insert(temp, atIndex: destinationIndexPath.row)
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        UserStore.bios = randBios
        
        println("prepped")
    }
}
