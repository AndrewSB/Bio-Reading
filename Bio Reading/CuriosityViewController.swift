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
    
    var parseRecord: PFObject!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        parseRecord["curiosity"] = howCuriousSlider.value
        
        if let des = segue.destinationViewController as? PromptViewController {
            des.parseRecord = self.parseRecord
            des.title = navigationItem.title
            des.index = index
            des.person = person
        }
    }
}
