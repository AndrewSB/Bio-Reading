//
//  RecallViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import AVFoundation

import Parse

class RecallViewController: UIViewController {
    
    @IBOutlet weak var waveView: EZAudioPlotGL!
    @IBOutlet weak var recordButton: UIButton!

    let soundFileURL = NSURL(fileURLWithPath: (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String).stringByAppendingPathComponent("\(UserStore.subjectNumber!):\(NSUUID().UUIDString)sound.wav"))!
    
    var isRecording: Bool = false {
        didSet {
            if isRecording {
                mic.startFetchingAudio()
            } else {
                mic.stopFetchingAudio()
            }
        }
    }
    
    var mic = EZMicrophone()
    var recorder = EZRecorder()
    
    var parseRecord: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mic = EZMicrophone(microphoneDelegate: self)
        
        waveView.plotType = .Rolling
        waveView.shouldFill = true
        waveView.shouldMirror = true
        
        isRecording = true
        
        recorder = EZRecorder(destinationURL: soundFileURL, sourceFormat: mic.audioStreamBasicDescription(), destinationFileType: .WAV)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        let cueNumber = (segue.destinationViewController as? PromptPickerViewController)!.curSentance!
        saveRecord(cueNumber)
        
        if let des = segue.destinationViewController as? FamiliarityViewController {
            des.person = NSUserDefaults.standardUserDefaults().objectForKey("currentPerson") as! String
        }
    }
}


// EZMicrophone
extension RecallViewController: AVAudioPlayerDelegate, EZMicrophoneDelegate {
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), {
            self.waveView.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        if self.isRecording {
            self.recorder.appendDataFromBufferList(bufferList, withBufferSize: bufferSize)
        }
    }
    
    private func saveRecord(cueNumber: Int) {
        parseRecord["audioFile"] = PFFile(name: "Audio\(UserStore.subjectNumber!)-\(UserStore.bios[UserStore.currentBio!].0)-\(cueNumber)".stringByReplacingOccurrencesOfString(" ", withString: "_").stringByReplacingOccurrencesOfString("-", withString: "_"), data: NSData(contentsOfURL: soundFileURL)!)
        isRecording = false
        
        self.parseRecord.pinInBackgroundWithBlock({(success: Bool, error: NSError?) -> Void in
            println("pinned")
        })
    }
}