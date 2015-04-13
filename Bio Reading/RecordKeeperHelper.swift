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
    
    func getGlobalInstance() -> RecordStore {
        if let gRS = globalRecordStore {
            return gRS
        } else {
            globalRecordStore = RecordStore()
            return globalRecordStore!
        }
    }
    
    func createNewEntry(subjectNumber: Int) -> RecordEntry {
        curRecord = RecordEntry()
        curRecord!.subjectNumber = subjectNumber
        return curRecord!
    }
    
    func writeToDisk() {
        var writeString = ""
        for record in records {
            
        }
    }
    
    private func getRecordFile() {

    }
}

class RecordEntry: NSObject {
    enum BioPersons: Int {
        case Curie = 1
        case Shakespeare = 2
        case Newton = 3
        case Teresa = 4
        case Dickinson = 5
        case Gandhi = 6
    }
    
    enum Condtion: Int {
        case Foraging = 1
        case Control = 2
    }
    
    enum RTCond: Int {
        case Increasing = 1
        case Decreasing = 2
    }
    
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