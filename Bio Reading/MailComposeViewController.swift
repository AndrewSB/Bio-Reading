//
//  MailComposeViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 5/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import MessageUI

class MailComposeViewController: MFMailComposeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
