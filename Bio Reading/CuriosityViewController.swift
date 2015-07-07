//
//  CuriosityViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 3/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import Parse

class CuriosityViewController: UIViewController {
    
    @IBOutlet weak var howCuriousLabel: UILabel!
    @IBOutlet weak var howCuriousSlider: UISlider!
    
    var person: String!
    var index: Int!
    
    var curRecord: Record!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        curRecord.curiosity = NSDecimalNumber(float: howCuriousSlider.value)
        
        if let des = segue.destinationViewController as? PromptViewController {
            des.curRecord = self.curRecord
            des.title = navigationItem.title
            des.index = index
            des.person = person
        }
    }
}
