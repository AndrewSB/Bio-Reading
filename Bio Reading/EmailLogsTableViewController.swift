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

class EmailLogsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    var subjectRecords: [Record]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectRecords = appDel.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "Record"), error: nil) as? [Record]
        
        for s in subjectRecords! {
            println(s)
        }
        
        tableView.reloadData()
    }
    
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
        return subjectRecords == nil ? 0 : subjectRecords!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = "\(subjectRecords![indexPath.row].bioPerson)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let email = createEmail(subjectRecords![indexPath.row].subjectNumber as! Int)
        println(email)
        
        presentViewController(email, animated: true, completion: nil)
    }
    
    func createEmail(subjectNumber: Int) -> MFMailComposeViewController {
        let email = MFMailComposeViewController(rootViewController: self)
        
        email.title = "Subject \(subjectNumber), Adult Learning Lab"
        email.setToRecipients(["a@ndrew.me"])
            
        email.addAttachmentData(("asdasdasdas,das,das,da,sd,as,da" as NSString).dataUsingEncoding(NSUTF8StringEncoding), mimeType: "text/csv", fileName: "subject.csv")
        
//            if count(relevantString) > 0 {
//                let comps = split(relevantString) {$0 == ","}
//                if NSFileManager.defaultManager().fileExistsAtPath(comps[comps.count - 1]) {
//                    email.addAttachmentData(NSFileManager.defaultManager().contentsAtPath(comps[comps.count - 1]), mimeType: "audio/wav", fileName: "audio.wav")
//                }
//            }
//            
            return email
//        }
    }
}
