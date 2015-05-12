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
        
        isRecording = true
        
        recorder = EZRecorder(destinationURL: soundFileURL, sourceFormat: mic.audioStreamBasicDescription(), destinationFileType: .WAV)
    }
    
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        appDel.currentRecord!.audioFile = NSData(contentsOfURL: soundFileURL)!
        isRecording = false
        
        if let des = segue.destinationViewController as? FamiliarityViewController {
            des.person = NSUserDefaults.standardUserDefaults().objectForKey("currentPerson") as! String
        }
    }
}
