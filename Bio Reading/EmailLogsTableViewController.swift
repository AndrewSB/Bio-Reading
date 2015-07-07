//
//  EmailLogsTableViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import MessageUI
import CoreData
import Parse

class EmailLogsTableViewController: UITableViewController {
    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
    var subjectRecords: [Record]?
    var sortedRecords = Dictionary<Int, [Record]!>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.userInteractionEnabled = false
        let spinner = UIActivityIndicatorView(view: view)
        view.addSubview(spinner)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.subjectRecords = self.appDel.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "Record"), error: nil) as? [Record]
            
            for record in self.subjectRecords! {
                let n = record.subjectNumber as! Int
                
                if self.sortedRecords[n] == nil {
                    self.sortedRecords[n] = [Record]()
                }
                
                if record.dateTime != nil {
                    self.sortedRecords[n]!.append(record)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.view.userInteractionEnabled = true
                
                spinner.stopAnimating()
                spinner.removeFromSuperview()
            })
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let des = segue.destinationViewController as? SubjectLogTableViewController {
            des.records = sender as! [Record]
        }
    }
    
}


// MARK: - Table view data source
extension EmailLogsTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedRecords.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "Subject \(sortedRecords.keys.array[indexPath.row])"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueToDetail", sender: sortedRecords[sortedRecords.keys.array[indexPath.row]])
    }
    
}