//
//  CuriosityViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 3/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class CuriosityViewController: UIViewController {
    @IBOutlet weak var howCuriousLabel: UILabel!
    @IBOutlet weak var curiosityLabel: UILabel!
    
    var person = String()
    var index = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        howCuriousLabel.text = "How Curious are you about \(person)'s \(title!)?"
        curiosityLabel.text = "3"
        
        println(" lol \(navigationItem.title)")

    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        curiosityLabel.text = "\(Int((sender as! UISlider).value))"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        RecordStore.defaultStore().curRecord!.curiosity = curiosityLabel.text?.toInt()
        (segue.destinationViewController as? PromptViewController)?.title = navigationItem.title
        (segue.destinationViewController as? PromptViewController)?.index = index
        (segue.destinationViewController as? PromptViewController)?.person = person
    }
}
