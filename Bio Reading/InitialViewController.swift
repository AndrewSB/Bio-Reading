//
//  ViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    var swiped = false {
        didSet {
            if swiped {
                self.performSegueWithIdentifier("segueToAdmin", sender: self)
            }
        }
    }
    
    @IBAction func didSwipe(sender: AnyObject) {
        swiped = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        swiped = false
    }
    
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("segueToInstructions", sender: self)
    }
    
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue){}
}

