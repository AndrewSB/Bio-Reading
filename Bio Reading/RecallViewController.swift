//
//  RecallViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import AVFoundation

class RecallViewController: UIViewController {

    
    var isRecording = false
    @IBOutlet weak var recordButton: UIButton!
    
    func startRecording() {
        recordButton.setTitle("Stop recording", forState: .Normal)
    }
    
    func endRecording() {
        recordButton.setTitle("Record again", forState: .Normal)
    }
    
    
    @IBAction func recordButtonWasHit(sender: AnyObject) {
        if isRecording {
            endRecording()
        } else {
            startRecording()
        }
    }
}
