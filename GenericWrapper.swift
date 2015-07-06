//
//  GenericWrapper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

// This data structure is used to store Bios in NSUserDefaults

import Foundation

class GenericWrapper<T> {
    let element: T
    
    init(element: T) {
        self.element = element
    }
    
}

class GenericBio: NSObject, NSCoding {
    var person: String
    var foraging: Bool
    
    init(person: String, foraging: Bool) {
        self.person = person
        self.foraging = foraging
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(person, forKey: "person")
        aCoder.encodeObject(foraging, forKey: "foraging")
    }
    
    required init(coder aDecoder: NSCoder) {
        person = aDecoder.decodeObjectForKey("person") as! String
        foraging = aDecoder.decodeObjectForKey("foraging") as! Bool
        super.init()
    }
}