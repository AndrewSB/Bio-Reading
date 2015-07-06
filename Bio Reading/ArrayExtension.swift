//
//  ArrayExtension.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/27/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

extension Array {
    
    func getRandomElement() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }

}