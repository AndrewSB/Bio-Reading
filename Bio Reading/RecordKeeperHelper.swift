//
//  RecordKeeperHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/13/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

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
        var writeString = ""
        for record in records {
            
        }
    }
    
    private func getRecordFile() {

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
    var subjectNumber: Int?
    var dateTime: NSDate?
    
    var bioPerson: BioPersons?
    var condition: Condtion?
    
    var cue: Int?
    var order: Int?
    
    var curiosity: Int?
    var familiarity: Int?
    
    var readingTime: NSTimeInterval?
    
    var audioFile: NSURL?
}