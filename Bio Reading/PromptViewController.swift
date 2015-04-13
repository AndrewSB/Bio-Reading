//
//  PromptViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class PromptViewController: UIViewController {
    var index = Int()
    var person = String()
    var isTimed = NSUserDefaults.standardUserDefaults().objectForKey("timed") as! Bool
    
    let startTime = NSDate()
    var timer: NSTimer?
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promptLabel.text = IO.getSentance(person, index: index)
        
        navigationItem.title = title
        
        if isTimed {
            setupTimer(continueButton)
        }
    }
    @IBAction func contineButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToRecall", sender: self)
    }
    
    func setupTimer(button: UIButton) {
        timer = NSTimer(timeInterval: NSTimeInterval(1), target: self, selector: "secondPassed:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        println("continue button is a timer")
        
        continueButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        continueButton.userInteractionEnabled = false
        continueButton.setTitle("4", forState: .Normal)
    }
    
    func secondPassed(id: AnyObject!) {
        if let t = continueButton.titleLabel?.text?.toInt() {
            continueButton.setTitle("\(t - 1)", forState: .Normal)
            
            if t <= 0 {
                timer?.invalidate()
                self.performSegueWithIdentifier("segueToRecall", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        let timeTaken = NSDate().timeIntervalSinceDate(startTime)
    }
    
    @IBAction func unwindToPromptViewController(segue: UIStoryboardSegue) {}
}
