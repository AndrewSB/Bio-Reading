//
//  PromptViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Darwin

import Parse

class PromptViewController: UIViewController {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    var index: Int!
    var person: String!
    var isTimed = NSUserDefaults.standardUserDefaults().objectForKey("timed") as! Bool
    
    var startTime: NSDate!
    var timer: NSTimer?
    
    var curRecord: Record!
    
    var curTime = UserStore.currentTime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promptLabel.font = UIFont.HelveticaNeue()
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
        globalTimerLabel.start()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println(NSDate().timeIntervalSinceDate(startTime))
        globalTimerLabel.pause()
    }
    
    @IBAction func contineButtonWasHit(sender: AnyObject) {
        performSegueWithIdentifier("segueToRecall", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let time = NSDate().timeIntervalSinceDate(startTime) as Double
        
        curRecord.readingTime = time
        
        if let des = segue.destinationViewController as? RecallViewController {
            des.curRecord = self.curRecord
        }
    }
    
    @IBAction func unwindToPromptViewController(segue: UIStoryboardSegue) {}
}
