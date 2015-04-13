//
//  FamiliarityViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 3/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class FamiliarityViewController: UIViewController {
    @IBOutlet weak var howCuriousLabel: UILabel!
    
    var person = String()
    var index = Int()
    
    override func viewDidLoad() {
        let cT = "currentTitle"
        super.viewDidLoad()
        
        println(" lol \(navigationItem.title)")
        
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        RecordStore.defaultStore().curRecord!.familiarity = curiosityLabel.text?.toInt()
        (segue.destinationViewController as? PromptViewController)?.title = navigationItem.title
        (segue.destinationViewController as? PromptViewController)?.index = index
        (segue.destinationViewController as? PromptViewController)?.person = person
    }
}
