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
    
    var spinner: UIActivityIndicatorView!
    
    var parsing = false {
        didSet {
            if parsing {
                spinner = UIActivityIndicatorView(view: view)
                view.addSubview(spinner)
                view.userInteractionEnabled = false
            } else {
                spinner.stopAnimating()
                spinner.removeFromSuperview()
                view.userInteractionEnabled = true
            }
        }
    }
}


// MARK: - Table view data source
extension SubjectLogTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
      
      println(records[indexPath.row])
        
        cell.textLabel?.text = "\(records[indexPath.row].bioPerson) - \(records[indexPath.row].order)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        audioPlayer = AVAudioPlayer(data: records[indexPath.row].audioFile, fileTypeHint: "wav", error: nil)
        audioPlayer.play()
    }
    
}

extension SubjectLogTableViewController: MFMailComposeViewControllerDelegate {
    
    @IBAction func email(sender: UIBarButtonItem) {
        let CSV = join("\n", records.map({ "\($0.stringified)" }))
        
        let email = MFMailComposeViewController()
        email.setSubject("Subject \(records[0].subjectNumber)")
        email.addAttachmentData(NSString(string: CSV).dataUsingEncoding(NSUTF8StringEncoding), mimeType: "text/csv", fileName: "\(records[0].subjectNumber)")
      
        self.presentViewController(email, animated: true, completion: nil)
    }

    
    @IBAction func parse(sender: UIBarButtonItem) {
        parsing = true
        recursiveSave(records)
    }
    
    private func recursiveSave(toSave: [Record]) {
        if toSave.count != 0 {
            var iArr = toSave
            if let last = iArr.removeLast().parsified {
                last.saveInBackgroundWithBlock({
                    if !$0.0 {
                        let alertController = UIAlertController(title: "Error saving to parse", message: $0.1?.localizedDescription, preferredStyle: .Alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    self.recursiveSave(iArr)
                })
            } else {
                self.recursiveSave(iArr)
            }
        } else {
            parsing = false
        }
    }
    
}