//
//  IOHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

let people = ["Marie Curie"]

func getPrompt(file: String, index: Int) -> String? {
    if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
        let rootDict = NSDictionary(contentsOfFile: plist)!

        return rootDict.allKeys[index] as? String
    }
    return nil
}

func getSentance(file: String, index: Int) -> String? {
    if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
        let rootDict = NSDictionary(contentsOfFile: plist)!

        return rootDict[rootDict.allKeys[index] as String]!["Sentance"] as String
    }
    return nil
}