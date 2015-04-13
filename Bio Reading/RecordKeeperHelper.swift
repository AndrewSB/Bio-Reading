//
//  RecordKeeperHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import AVFoundation

var globalRecordStore: RecordStore?

class RecordStore {
    var records: [RecordEntry]
    var curRecord: RecordEntry?
    
    init() {
        self.records = [RecordEntry]()
        self.curRecord = nil
    }
    
    class func defaultStore() -> RecordStore {
        if let gRS = globalRecordStore {
            return gRS
        } else {
            globalRecordStore = RecordStore()
            return globalRecordStore!
        }
    }
    
    func writeToDisk() {
        var writeString: String = UserStore.recordString == nil ? "" : UserStore.recordString!
        for record in records {
            writeString += "\(record.subjectNumber),\(record.dateTime),\(record.bioPerson!.hashValue),\(record.condition!.hashValue),\(record.cue!),\(record.order!),\(record.curiosity!),\(record.familiarity!),\(record.readingTime!)"
            if let aFile = record.audioFile {
                writeString += ",\(aFile.absoluteString)"
            }
            writeString += "\n"
        }
        UserStore.recordString = writeString
        
        globalRecordStore = nil
    }
}

enum Condtion: Int {
    case Foraging = 1
    case Control = 2
}

enum RTCond: Int {
    case Increasing = 1
    case Decreasing = 2
}


class RecordEntry: NSObject {
    var subjectNumber = UserStore.subjectNumber!
    var dateTime = NSDate()
    
    var bioPerson: BioPersons?
    var condition: Condtion?
    
    var cue: Int?
    var order: Int?
    
    var curiosity: Int?
    var familiarity: Int?
    
    var readingTime: NSTimeInterval?
    
    var audioFile: NSURL?
}