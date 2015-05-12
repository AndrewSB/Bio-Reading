//
//  ViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    var swiped = false
    var pinched = false {
        didSet {
            if swiped && pinched {
                self.performSegueWithIdentifier("segueToAdmin", sender: self)
            }
        }
    }
    
    @IBAction func didSwipe(sender: AnyObject) {
        swiped = true
    }
    @IBAction func didPinch(sender: AnyObject) {
        pinched = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        swiped = false
        pinched = false
    }
    
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("segueToInstructions", sender: self)
    }
    
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue){}
}

