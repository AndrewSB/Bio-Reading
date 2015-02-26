//
//  InstructionViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/25/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    var foraging = Bool()
    var practice = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: self)
        
        (segue.destinationViewController as PromptPickerViewController).foraging = foraging
        (segue.destinationViewController as PromptPickerViewController).practice = practice
    }
}
