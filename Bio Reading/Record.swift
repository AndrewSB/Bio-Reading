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

    @NSManaged var subjectNumber: NSNumber
    @NSManaged var dateTime: NSDate
    @NSManaged var bioPerson: String
    @NSManaged var condition: NSNumber
    @NSManaged var cue: NSNumber
    @NSManaged var order: NSNumber
    @NSManaged var curiosity: NSNumber
    @NSManaged var readingTime: NSNumber
    @NSManaged var audioFile: NSData

}
