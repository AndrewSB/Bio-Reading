//
//  RecallViewController.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/8/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
import AVFoundation

class RecallViewController: UIViewController, AVAudioPlayerDelegate, EZMicrophoneDelegate {

    var isRecording = false
    @IBOutlet weak var recordButton: UIButton!
    
    var mic = EZMicrophone()
    var recorder = EZRecorder()
    
    @IBOutlet weak var waveView: EZAudioPlotGL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mic = EZMicrophone(microphoneDelegate: self)
        waveView.plotType = .Rolling
        waveView.shouldFill = true
        waveView.shouldMirror = true
        
        let soundFilePath =
        (NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as String).stringByAppendingPathComponent("sound.wav")
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)

        
        mic.startFetchingAudio()
        
        recorder = EZRecorder(destinationURL: soundFileURL!, sourceFormat: mic.audioStreamBasicDescription(), destinationFileType: EZRecorderFileType.WAV)
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), {
            self.waveView.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
    
    func microphone(microphone: EZMicrophone!, hasBufferList bufferList: UnsafeMutablePointer<AudioBufferList>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        mic.stopFetchingAudio()
        
        if let des = segue.destinationViewController as? FamiliarityViewController {
            des.person = NSUserDefaults.standardUserDefaults().objectForKey("currentPerson") as String
        }
    }
}
