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

class EmailLogsTableViewController: UITableViewController {
    var subjectRecords: [Record]!
    var sortedRecords = [[Record]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectRecords = appDel.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "Record"), error: nil) as? [Record]
        
        for r in subjectRecords {
            ifExistsAppend(r)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedRecords.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "\(sortedRecords[indexPath.row][0].subjectNumber)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let composeEmailVC = MailComposeViewController()
        
        composeEmailVC.setSubject("Subject \(subjectRecords![indexPath.row]), Adult Learning Lab")
        composeEmailVC.setToRecipients(["xliu85@illinois.edu"])
        composeEmailVC.addAttachmentData(("asdasdasdas,das,das,da,sd,as,da" as NSString).dataUsingEncoding(NSUTF8StringEncoding), mimeType: "text/csv", fileName: "subject.csv")
        
        presentViewController(composeEmailVC, animated: true, completion: nil)
    }
    
    func ifExistsAppend(n: Record) {
        var inserted = false
        for (index, element) in enumerate(sortedRecords) {
            if element[0].subjectNumber == n.subjectNumber {
                sortedRecords[index].append(n)
                inserted = true
            }
        }
        
        if !inserted {
            sortedRecords.append([n])
        }
    }
}
