//
//  FamiliarityAlertController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 5/24/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class FamiliarityAlertController: UIAlertController {
    
    var person: String?
    var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sliderView = UIView(frame: CGRect(x: 40, y: 88, width: 188, height: 44))
        
        slider = UISlider(frame: CGRect(x: 0, y: 11, width: sliderView.frame.width, height: 22))
        slider.minimumValue = 0
        slider.maximumValue = 100
        
        sliderView.addSubview(slider)
        self.view.addSubview(sliderView)
    }
}
