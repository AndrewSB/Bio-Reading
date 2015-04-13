//
//  InstructionViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let num = UserStore.subjectNumber {} else {
            let alert = UIAlertController(title: "WARNING", message: "No subject number has been set. This record will not be saved", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapGestureTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
