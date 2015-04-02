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
    @IBOutlet weak var curiosityLabel: UILabel!
    
    var person = String()
    var index = Int()
    
    override func viewDidLoad() {
        let cT = "currentTitle"
        super.viewDidLoad()
        howCuriousLabel.text = "How Familar are you with \(person)'s \(NSUserDefaults.standardUserDefaults().objectForKey(cT)!)"
        curiosityLabel.text = "3"
        
        println(" lol \(navigationItem.title)")
        
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        curiosityLabel.text = "\(Int((sender as UISlider).value))"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as? PromptViewController)?.title = navigationItem.title
        (segue.destinationViewController as? PromptViewController)?.index = index
        (segue.destinationViewController as? PromptViewController)?.person = person
    }
}
