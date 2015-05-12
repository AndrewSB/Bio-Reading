////
////  RecordKeeperHelper.swift
////  Bio Reading
////
////  Created by Andrew Breckenridge on 4/13/15.
////  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
////
//
//import AVFoundation
//import MessageUI
//
//var globalRecordStore: RecordStore?
//
//class RecordStore {
//    var firstSubjectNumber: Int?
//    var records: [RecordEntry]
//    var curRecord: RecordEntry?
//    
//    init() {
//        self.records = [RecordEntry]()
//        self.curRecord = nil
//    }
//    
//    class func defaultStore() -> RecordStore {
//        if let gRS = globalRecordStore {
//            return gRS
//        } else {
//            globalRecordStore = RecordStore()
//            return globalRecordStore!
//        }
//    }
//    
//    func writeToDisk() {
//        var writeString: String = UserStore.recordString == nil ? "" : UserStore.recordString!
//        for record in records {
//            writeString += "\(record.subjectNumber),\(record.dateTime),\(record.bioPerson?.hashValue),\(record.condition?.hashValue),\(record.cue),\(record.order),\(record.curiosity),\(record.familiarity),\(record.readingTime)"
//            if let aFile = record.audioFile {
//                writeString += ",\(aFile.absoluteString)"
//            }
//            writeString += "\n"
//        }
//        UserStore.recordString = writeString
//    }
//    
//    class func getSubjectNumbers() -> [Int]? {
//        var readString = UserStore.recordString
//        if let rString = readString {
//            var returner = [Int]()
//            let arr = split(rString) {$0 == "\n"}
//            for a in arr {
//                let comps = split(a) {$0 == ","}
//                if let i = comps[0].toInt() {
//                    returner.append(i)
//                }
//            }
//            return returner.count == 0 ? nil : returner
//        }
//        return nil
//    }
//    
//    class func emailSubjectString(subjectNumber: Int, vc: UIViewController) -> MFMailComposeViewController {
//        var relevantString: String = ""
//        let email = MFMailComposeViewController(rootViewController: vc)
//        
//        var readString = UserStore.recordString
//        if let rString = readString {
//            var returner = [Int]()
//            let arr = split(rString) {$0 == "\n"}
//            for a in arr {
//                let comps = split(a) {$0 == ","}
//                if let i = comps[0].toInt() {
//                    if i == subjectNumber {
//                        relevantString = a
//                    }
//                }
//            }
//        }
//        
//        email.title = "Subject \(subjectNumber), Adult Learning Lab"
//        email.setToRecipients(["a@ndrew.me"])
//        
//        email.addAttachmentData((relevantString as NSString).dataUsingEncoding(NSUTF8StringEncoding), mimeType: "text/csv", fileName: "subject.csv")
//        
//        if count(relevantString) > 0 {
//            let comps = split(relevantString) {$0 == ","}
//            if NSFileManager.defaultManager().fileExistsAtPath(comps[comps.count - 1]) {
//                email.addAttachmentData(NSFileManager.defaultManager().contentsAtPath(comps[comps.count - 1]), mimeType: "audio/wav", fileName: "audio.wav")
//            }
//        }
//
//        return email
//    }
//        
//}
//
//enum Condtion: Int {
//    case Foraging = 1
//    case Control = 2
//}
//
//enum RTCond: Int {
//    case Increasing = 1
//    case Decreasing = 2
//}
//
//
//class RecordEntry: NSObject {
//    var subjectNumber = UserStore.subjectNumber!
//    var dateTime = NSDate()
//    
//    var bioPerson: BioPersons?
//    var condition: Condtion?
//    
//    var cue: Int?
//    var order: Int?
//    
//    var curiosity: Int?
//    var familiarity: Int?
//    
//    var readingTime: NSTimeInterval?
//    
//    var audioFile: NSURL?
//}