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
    @IBOutlet weak var slider: UISlider!
    
    var person = String()
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonWasHit() {

        self.performSegueWithIdentifier("unwindToPrompt", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        UserStore.currentFamiliarity = Double(slider.value)
        (segue.destinationViewController as! PromptPickerViewController).curPersonIndex++
    }
}
