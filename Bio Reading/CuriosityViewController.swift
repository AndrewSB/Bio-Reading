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

    override func viewDidLoad() {
        super.viewDidLoad()
        howCuriousLabel.text = "How Curious are you about \(person)'s \(title!)"
        curiosityLabel.text = "\(8-0/2)"

    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        curiosityLabel.text = "\(Int((sender as UISlider).value))"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
