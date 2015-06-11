//
//  MailComposeViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 5/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import MessageUI

class MailComposeViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mailComposeDelegate = self
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        println("rans")
        let alert = UIAlertController(title: "Uh oh!", message: "The email didn't send \(error.localizedDescription)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        
        if error != nil {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
