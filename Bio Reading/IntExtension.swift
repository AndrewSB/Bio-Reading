//
//  IntExtension.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 6/11/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

extension Int {
    
    func secondsToString() -> String {
        var str = ""
        let triple = self.secondsToHoursMinutesSeconds()

        if triple.0 != 0 { str += "\(triple.0):" }
        if triple.1 != 0 || str != "" {
            if str != "" && triple.1 < 10{
                str += "0"
            }
            str += "\(triple.1):"
        }
        if triple.2 != 0 || str != "" {
            if str != "" && triple.2 < 10{
                str += "0"
            }
            str += "\(triple.2)"
        }
        
        return str
    }
    
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
    
}