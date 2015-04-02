//
//  InstructionViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    @IBOutlet weak var continueButton: UIButton!
    
    var foraging = Bool()
    var practice = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        
        if let des = segue.destinationViewController as? PromptPickerViewController {
            
            des.practice = continueButton.titleLabel?.text == "Practice"
            des.foraging = foraging
        }
    }
}
