//
//  PromptViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Darwin

class PromptViewController: UIViewController {
    var index = Int()
    var person = String()
    var isTimed = NSUserDefaults.standardUserDefaults().objectForKey("timed") as! Bool
    
    var startTime: NSDate!
    var timer: NSTimer?
    
    var curTime = UserStore.currentTime!
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promptLabel.font = UIFont(name: "HelveticaNeue", size: get("fontSize") as! CGFloat)
        
        promptLabel.text = IO.getSentance(person, index: index)
        
        navigationItem.title = title
        
        if isTimed {
            continueButton.hidden = true
            self.view.userInteractionEnabled = false
        } else {
            continueButton.hidden = false
            self.view.userInteractionEnabled = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startTime = NSDate()
        
        if isTimed {
            usleep(UInt32(curTime * 1000000))
            contineButtonWasHit(self)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println(NSDate().timeIntervalSinceDate(startTime))
        appDel.currentRecord!.readingTime = NSDate().timeIntervalSinceDate(startTime)
    }
    
    @IBAction func contineButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToRecall", sender: self)
    }
    
    @IBAction func unwindToPromptViewController(segue: UIStoryboardSegue) {}
}
