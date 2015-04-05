//
//  IOHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

class IO {
    class var people: [String] {
        get {
            return ["Marie Curie", "William Shakespeare", "Issac Newton", "Mother Teresa", "Emily Dickinson", "Mahatma Gandhi"]
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
            
            return rootDict[rootDict.allKeys[index] as String]!["Sentance"] as? String
        }
        return nil
    }
}