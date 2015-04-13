//
//  ViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBAction func tapRecognizerTapped(sender: AnyObject) {
        performSegueWithIdentifier("segueToAdmin", sender: self)
    }

    @IBAction func startButtonTapped(sender: AnyObject) {
        performSegueWithIdentifier("segueToInstructions", sender: self)
    }
    
    @IBAction func unwindToInitialViewController(segue: UIStoryboardSegue){}
}

