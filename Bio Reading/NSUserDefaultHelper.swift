//
//  NSUserDefaultHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

let set = NSUserDefaults.standardUserDefaults().setObject
let get = NSUserDefaults.standardUserDefaults().objectForKey

class UserStore {
    enum storeKeys: String {
        case currentBio = "currentBio"
        case bios = "bios"
        case subjectNumber = "subjectNumber"
    }
    
    class var subjectNumber: Int? {
        get {
            return get(storeKeys.subjectNumber.rawValue) as? Int
        }
        set {
            set(newValue, forKey: storeKeys.subjectNumber.rawValue)
        }
    }
    
    class var currentBio: Int? {
        get {
            return get(storeKeys.currentBio.rawValue) as? Int
        }
        set {
            set(newValue, forKey: storeKeys.currentBio.rawValue)
        }
    }
    
    class var bios: [(String, Bool)] {
        get {
            let w = NSKeyedUnarchiver.unarchiveObjectWithData(get(storeKeys.bios.rawValue) as! NSData) as! [GenericBio]
        
            var arr = [(String, Bool)]()
            for p in w {
                arr.append((p.person, p.foraging))
            }
            return arr
        }
        set {
            var arr = [GenericBio]()
            for p in newValue {
                arr.append(GenericBio(person: p.0, foraging: p.1))
            }
            let wData = NSKeyedArchiver.archivedDataWithRootObject(arr)
            set(wData, forKey: storeKeys.bios.rawValue)
            
        }
    }
    
    class func generateRandomBios() -> [(String, Bool)] {
        var randBios = [(String, Bool)]()
        var allBios = IO.people
        
        for i in 0...2 {
            let index = Int(arc4random_uniform(UInt32(allBios.count)))
            let d = allBios[index]
            
            let tF = arc4random_uniform(1) == 0 ? true : false
            
            randBios.append((d, tF))
            
            allBios.removeAtIndex(index)
            
            let otherIndex = Int(arc4random_uniform(UInt32(allBios.count)))
            randBios.append((allBios[otherIndex], !tF))
            
            allBios.removeAtIndex(otherIndex)
        }
        
        return randBios
    }
}