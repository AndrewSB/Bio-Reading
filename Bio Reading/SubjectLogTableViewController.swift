//
//  SubjectLogTableViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 7/7/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import MessageUI
import AVFoundation
import Parse
import CoreData

class SubjectLogTableViewController: UITableViewController {
    
    var records: [Record]!
    var audioPlayer: AVAudioPlayer! = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

}


// MARK: - Table view data source
extension SubjectLogTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = "\(records[indexPath.row].bioPerson) - \(records[indexPath.row].cue)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        audioPlayer.stop()
        audioPlayer = nil
        audioPlayer = AVAudioPlayer(data: records[indexPath.row].audioFile, fileTypeHint: "wav", error: nil)
    }
    
}

extension SubjectLogTableViewController: MFMailComposeViewControllerDelegate {
    
    @IBAction func email(sender: UIBarButtonItem) {
        let CSV = join("\n", records.map({ "\($0.stringified)" }))
        
        let email = MFMailComposeViewController()
        email.setSubject("Subject \(records[0].subjectNumber!)")
        email.addAttachmentData(NSString(string: CSV).dataUsingEncoding(NSUTF8StringEncoding), mimeType: "text/csv", fileName: "\(records[0].subjectNumber!)")
    }

    
    @IBAction func parse(sender: UIBarButtonItem) {
        recursiveSave(records)
    }
    
    private func recursiveSave(toSave: [Record]) {
        if toSave.count != 0 {
            var iArr = toSave
            iArr.removeLast().parsified.saveInBackgroundWithBlock({
                if !$0.0 {
                    let alertController = UIAlertController(title: "Error saving to parse", message: $0.1?.localizedDescription, preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                self.recursiveSave(iArr)
            })
        }
    }
    
}