//
//  Bio_Reading.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 7/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreData

class Record: NSManagedObject {

    @NSManaged var audioFile: NSData
    @NSManaged var bioPerson: String
    @NSManaged var condition: NSNumber
    @NSManaged var cue: NSNumber
    @NSManaged var curiosity: NSNumber
    @NSManaged var dateTime: NSDate
    @NSManaged var familiarity: NSNumber
    @NSManaged var order: NSNumber
    @NSManaged var readingTime: NSNumber
    @NSManaged var rTCond: NSNumber
    @NSManaged var subjectNumber: NSNumber

    var stringified: String {
        get {
            return join(",", [subjectNumber, curiosity, familiarity, bioPerson, cue, order, rTCond, dateTime, readingTime].map({"\($0)"}))
        }
    }
}
