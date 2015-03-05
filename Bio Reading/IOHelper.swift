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
        
        println("\(rootDict[index])")
        
        let lessrootDict = (rootDict[index]).objectForKey("Spouse" as AnyObject?)?.value as String
        
        return lessrootDict//[NSString(string: String("sentance"))] as String
    } else {
        return "error in getting prompt"
    }
}