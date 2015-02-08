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
}
