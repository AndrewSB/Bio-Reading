//
//  NSUserDefaultHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

let set = NSUserDefaults.standardUserDefaults().setObject
let get = NSUserDefaults.standardUserDefaults().objectForKey

class UserStore {
    enum storeKeys: String {
        case currentBio = "currentBio"
        case bios = "bios"
    }
    
    class var currentBio: Int {
        get {
            if get(storeKeys.currentBio.rawValue) == nil {
                set(0, forKey: storeKeys.currentBio.rawValue)
            }
            return get(storeKeys.currentBio.rawValue) as Int
        }
        set {
            set(newValue, forKey: storeKeys.currentBio.rawValue)
        }
    }
    
    class var bios: [(String, Bool)] {
        get {
            if get(storeKeys.bios.rawValue) == nil {
                self.bios = generateRandomBios()
            }
            let wrappedBios = NSKeyedUnarchiver.unarchiveObjectWithData(get(storeKeys.bios.rawValue) as NSData) as GenericWrapper<[(String, Bool)]>
            return wrappedBios.element
        }
        set {
            let wrappedBios = GenericWrapper(element: generateRandomBios())
            set(NSKeyedArchiver.archivedDataWithRootObject(wrappedBios), forKey: storeKeys.currentBio.rawValue)
        }
    }
    
    class func generateRandomBios() -> [(String, Bool)] {
        
    }
}