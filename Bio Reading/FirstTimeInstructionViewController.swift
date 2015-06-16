//
//  FirstTimeInstructionViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 6/1/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

let foragingInstructions = "For this part of the experiment, you will be able to select the order of the passages and read at your own pace. You will learn biographical information about three different individuals. When you press the Start button, the name of the first person you will learn about will appear and you will rate how familiar you are with that person’s life. Next, a grid will appear in which each button contains a key word that provides a hint about the content of the passage. You can select the passage you want to read by pressing the button and then you will rate how curious you are about the passage based on the hint. After you make the curiosity rating, the passage will appear on the screen. When the sentence appears, you can take as much time as you would like to read it so that you can learn the information. Please read silently.\n\nWhen you are done, press “CONTINUE.” A microphone will then appear on the screen. When you see this signal, please recall aloud as much as you can remember from that sentence. Try to remember as many of the main ideas and details as you can. There is no need to try to recall the sentence word for word. Rather, try to remember the ideas that you learned. Doing this will help you learn the information so that you will be able to write down the highlights of this person’s life later. When you are done, press “DONE,” and the grid of buttons with the cues will appear again, and you can select another passage.\n\nRemember your goal is to learn as much about each person as possible. You will have 5 minutes to read as many passages as you can for each person. Your time spent on recall will not be counted towards the timer. When you have finished learning about all three people, you will be asked to write down some of the things that you learned.\n\nThe first one is for practice. Note that the practice is not a biography, but about a New England state.\n\nPlease let the experimenter know if you have any questions."

let controlInstructions = "For this part of the experiment, you will read passages that are selected for you. The passages will appear for different amounts of time. Some will be on the screen for a very short period of time and some will be on the screen for a very long time. Please do your best to take advantage of the time you have to learn the information in the passage. You will learn biographical information about three different individuals. When you press the Start button, the name of the first person you will learn about will appear and you will rate how familiar you are with that person’s life. Next, a grid will appear in which each button contains a key word that provides a hint about the content of the passage. The button with the hint for the passage that is to come will appear to light up with a yellow ring. Then, you will rate how curious you are about the passage based on the hint. After you make the curiosity rating, the passage will appear on the screen. When the sentence appears, do your best to learn the information. Please read silently.\n\nIf the time is very short, don’t worry if you feel like you didn’t get very much from it. Just try to learn as much as you can. On the hand, if the time feels very long, please try to use it to learn the information well. When the time is up, a microphone will appear on the screen. When you see this signal, please recall aloud as much as you can remember from that sentence. Try to remember as many of the main ideas and details as you can. There is no need to try to recall the sentence word for word. Rather, try to remember the ideas that you learned. Doing this will help you learn the information so that you will be able to write down the highlights of this person’s life later. When you are done, press “DONE,” and the grid of buttons with the cues will appear again, and the experiment will continue in this way.\n\nRemember your goal is to learn as much about each person as possible. When you have finished learning about all three people, you will be asked to write down some of the things that you learned.\n\nThe first one is for practice. Note that the practice is not a biography, but about a New England state.\n\nPlease let the experimenter know if you have any questions."

class FirstTimeInstructionViewController: UIViewController {
    @IBOutlet weak var instructionTextView: UITextView!
    var instructionText: String!
    var person: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionTextView.text = instructionText
        instructionTextView.font = UIFont(name: "HelveticaNeue", size: get("fontSize") as! CGFloat)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let des = segue.destinationViewController as? FamiliarityViewController {
            des.person = person
        }
    }
}
