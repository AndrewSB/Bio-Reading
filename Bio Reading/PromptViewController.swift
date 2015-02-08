//
//  PromptViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class PromptViewController: UIViewController {
    var navTitle = "Prompt"
    var isTimed = NSUserDefaults.standardUserDefaults().objectForKey("timed") as Bool
    
    let curTime = NSDate()
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = navTitle
        
        if isTimed {
            setupTimer(continueButton)
        }
    }
    @IBAction func contineButtonWasHit(sender: AnyObject) {
        println("continue")
    }
    
    func setupTimer(button: UIButton) {
        let timer = NSTimer(timeInterval: NSTimeInterval(1), target: self, selector: "secondPassed:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        println("continue button is a timer")
        
        continueButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        continueButton.userInteractionEnabled = false
        continueButton.setTitle("4", forState: .Normal)
    }
    
    func secondPassed(id: AnyObject!) {
        if let t = continueButton.titleLabel?.text?.toInt() {
            continueButton.setTitle("\(t - 1)", forState: .Normal)
            
            if t <= 0 {
                self.performSegueWithIdentifier("segueToRecall", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let 
    }
}
