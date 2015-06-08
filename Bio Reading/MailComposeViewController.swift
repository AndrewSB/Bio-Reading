//
//  MailComposeViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 5/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import MessageUI

class MailComposeViewController: MFMailComposeViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        let alert = UIAlertController(title: "Uh oh!", message: "The email didn't send \(error.localizedDescription)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        dismissViewControllerAnimated(true, completion: nil)
    }
}
