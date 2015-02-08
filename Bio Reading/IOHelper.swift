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
        let rootDict = NSArray(contentsOfFile: plist)!
        
        return rootDict[0][index] as String
    } else {
        return "error in getting prompt"
    }
}