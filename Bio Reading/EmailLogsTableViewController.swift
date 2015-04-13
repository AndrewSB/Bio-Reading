//
//  EmailLogsTableViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import MessageUI

class EmailLogsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    let subjectNumbers = RecordStore.getSubjectNumbers()
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        let alert = UIAlertController(title: "Uh oh!", message: "The email didn't send \(error.localizedDescription)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
//        switch result {
//        case .Cancelled:
//            presentViewController(alert, animated: true, completion: nil)
//        case .Failed:
//            presentViewController(alert, animated: true, completion: nil)
//        default:
//            println("lol")
//        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectNumbers == nil ? 0 : subjectNumbers!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "\(subjectNumbers![indexPath.row])"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let email = RecordStore.emailSubjectString(subjectNumbers![indexPath.row], vc: self as UIViewController)
        
        presentViewController(email, animated: true, completion: nil)
    }
}
