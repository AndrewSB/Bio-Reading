//
//  Record.swift
//  
//
//  Created by Andrew Breckenridge on 7/6/15.
//
//

import Foundation
import CoreData
import Parse

class Record: NSManagedObject {

    @NSManaged var audioFile: NSData!
    @NSManaged var bioPerson: String!
    @NSManaged var condition: NSNumber!
    @NSManaged var cue: NSNumber!
    @NSManaged var curiosity: NSDecimalNumber!
    @NSManaged var dateTime: NSDate!
    @NSManaged var familiarity: NSDecimalNumber!
    @NSManaged var order: NSNumber!
    @NSManaged var readingTime: NSNumber!
    @NSManaged var rTCond: String!
    @NSManaged var subjectNumber: NSNumber!
    @NSManaged var cpidr: NSNumber!
    @NSManaged var sentance: String!
    
    var stringified: String {
        get {
            return join(",", [subjectNumber, curiosity, familiarity, bioPerson, cue, order, rTCond, dateTime, readingTime].map({"\($0)"}))
        }
    }
    
    var parsified: PFObject {
        get {
            let subjectNumberString = "\(subjectNumber)".stringByReplacingOccurrencesOfString("-", withString: "_")
            
            let object = PFObject(className: "Subject\(subjectNumberString)")
            
            object["CPIDR"] = cpidr
            object["sentance"] = sentance
            
            let fileName = "Audio\(subjectNumberString)_\(bioPerson)_\(cue)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())
            object["audioFile"] = PFFile(name: fileName, data: audioFile, contentType: "audio/wav")
            
            object["bioPerson"] = bioPerson
            object["curiosity"] = curiosity
            object["dateTime"] = dateTime
            object["familiarity"] = familiarity
            object["order"] = order
            object["readingTime"] = readingTime
            object["subjectNumber"] = subjectNumber
            
            return object
        }
    }

}
