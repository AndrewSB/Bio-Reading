//
//  Record.swift
//  
//
//  Created by Andrew Breckenridge on 7/7/15.
//
//

import Foundation
import CoreData
import Parse

class Record: NSManagedObject {

    @NSManaged var audioFile: NSData!
    @NSManaged var bioPerson: String!
    @NSManaged var cpidr: NSNumber!
    @NSManaged var curiosity: NSDecimalNumber!
    @NSManaged var dateTime: NSDate!
    @NSManaged var familiarity: NSDecimalNumber!
    @NSManaged var order: NSNumber!
    @NSManaged var readingTime: NSNumber!
    @NSManaged var rTCond: String!
    @NSManaged var sentance: String!
    @NSManaged var subjectNumber: NSNumber!
  
  var stringified: String? {
    get {
        if dateTime != nil {
            return Optional<String>(join(",", [subjectNumber, curiosity, familiarity, bioPerson, order, rTCond, dateTime, readingTime].map({"\($0)"})))
        } else {
            return nil
        }
    }
  }
  
  var parsified: PFObject? {
    get {
        if dateTime != nil {
            let subjectNumberString = "\(subjectNumber)".stringByReplacingOccurrencesOfString("-", withString: "_")
            
            let object = PFObject(className: "Subject\(subjectNumberString)")
            
            object["CPIDR"] = cpidr
            object["sentance"] = sentance
            
            let fileName = "Audio\(subjectNumberString)_\(bioPerson)_\(order)".stringByReplacingOccurrencesOfString("-", withString: "_")
            object["audioFile"] = PFFile(name: fileName, data: audioFile, contentType: "audio/wav")
            
            object["bioPerson"] = bioPerson
            object["curiosity"] = curiosity
            object["dateTime"] = dateTime
            object["familiarity"] = familiarity
            object["order"] = order
            object["readingTime"] = readingTime
            object["subjectNumber"] = subjectNumber
            
            return object
        } else {
            return nil
        }
    }
  }

}
