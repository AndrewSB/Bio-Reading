//
//  IOHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit


typealias stringIntTuple = (String, Int)

enum BioPersons: String, Printable {
    case Curie = "Marie Curie"
    case Shakespeare = "William Shakespeare"
    case Newton = "Issac Newton"
    case Teresa = "Mother Teresa"
    case Dickinson = "Emily Dickinson"
    case Gandhi = "Mahatma Gandhi"
    
    static func fromRaw(person: String) -> BioPersons? {
        for bPerson in allValues {
            if person == bPerson.rawValue || person == bPerson.description {
                return bPerson
            }
        }
        return nil
    }
    
    var description: String {
        get {
            self.rawValue
            return self.rawValue.substringFromIndex(self.rawValue.rangeOfString(" ")!.endIndex)
        }
    }
    
    static let allValues = [Curie, Shakespeare, Newton, Teresa, Dickinson, Gandhi]
}

enum RTCond: Int {
    case Increasing = 0
    case Decreasing = 1
}



class IO {
    class var people: [String] {
        get {
            return BioPersons.allValues.map({$0.rawValue})
        }
    }
    
    class func getPrompt(file: String, index: Int) -> String? {
        if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
            let rootDict = NSDictionary(contentsOfFile: plist)!
            
            return rootDict.allKeys[index] as? String
        }
        return nil
    }
    
    class func getSentance(file: String, index: Int) -> String? {
        if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
            let rootDict = NSDictionary(contentsOfFile: plist)!
            
            return rootDict[rootDict.allKeys[index] as! String]!["Sentance"] as? String
        }
        return nil
    }
    
    class func getCPIDR(file: String, index: Int) -> Int? {
        if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
            let rootDict = NSDictionary(contentsOfFile: plist)!
            
            let relevantDict = rootDict[rootDict.allKeys[index] as! String]! as! NSDictionary
            
            let CPIDR = relevantDict["CPIDR"] as! Int
            println("\(CPIDR)")
            return CPIDR
        }
        return nil
    }
    
    class func calculateTime(CPIDR: Int, n: Int, rt: RTCond) -> Double {
        let decreasing = [5350, 5200, 5050]
        let increasing = [100, 250, 400]
        
        let offset = rt == .Increasing ? increasing : decreasing
        
        let innerBracket = rt == .Increasing ? (450 * n) : (-450 * n)
        let offseted = offset.getRandomElement() + innerBracket
        
        let millisecond = (Double(500) + Double((CPIDR * offseted)))
        return millisecond/1000
    }
    
    class func getNumSentances(file: String) -> Int? {
        if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
            let rootDict = NSDictionary(contentsOfFile: plist)!
            
            return rootDict.count
        }
        return nil

    }
}