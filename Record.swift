//
//  Record.swift
//  
//
//  Created by Andrew Breckenridge on 5/12/15.
//
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
    @NSManaged var order: NSNumber
    @NSManaged var readingTime: NSNumber
    @NSManaged var subjectNumber: NSNumber
    @NSManaged var familiarity: NSNumber
    @NSManaged var rTCond: NSNumber

}
