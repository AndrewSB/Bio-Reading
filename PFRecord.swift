//
//  PFRecord.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 6/15/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

import Parse
import Bolts

class PFRecord: PFObject {
    var subjectNumber: Int
    var curiosity: Int?
    var familiarity: Int?
    var bioPerson: String?
    var cue: Int?
    var order: Int?
    var rtCond: RTCond?
    var dateTime: NSDate?
    var readingTime: NSTimeInterval?
    var audioFile: PFObject?
    
    init(subjectNumber: Int) {
        self.subjectNumber = subjectNumber
        super.init(className: "Subject \(subjectNumber)")
    }
}
