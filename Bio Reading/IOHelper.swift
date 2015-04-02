//
//  IOHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import UIKit

func getPrompt(file: String, index: Int) -> String {
    if let plist = NSBundle.mainBundle().pathForResource("\(file)", ofType: "plist") {
        let rootDict = NSDictionary(contentsOfFile: plist)!
        
//        let keyValuePair = rootDict[rootDict.allKeys[index] as String] as NSDictionary
        
        return rootDict.allKeys[index] as String//keyValuePair.valueForKey("Sentance") as String
    
    } else {
        return "error in getting prompt"
    }
}