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
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionLabel.font = UIFont(name: "HelveticaNeue", size: get("fontSize") as! CGFloat)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let num = UserStore.subjectNumber {} else {
            let alert = UIAlertController(title: "WARNING", message: "No subject number has been set. This record will not be saved", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            UserStore.subjectNumber = 9999999
        }
    }
    @IBAction func startButtonTapped() {
        let alertC = FamiliarityAlertViewController(title: "Switching Bios!", message: "How familiar are you with \(UserStore.bios[0].0)?\n\n\n", preferredStyle: .Alert)
        
        alertC.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (alertController) in
            println("shizz \(alertC.slider.value)")
            UserStore.currentFamiliarity = Double(alertC.slider.value)
            
            self.performSegueWithIdentifier("segueToPicker", sender: self)
        }))
        
        self.presentViewController(alertC, animated: true, completion: nil)
    }
    
    @IBAction func tapGestureTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
