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
        case currentPerson = "currentPerson"
        case currentBio = "currentBio"
        case currentTitle = "currentTitle"
        case currentTime = "currentTime"
        
        
        case bios = "bios"
        case subjectNumber = "subjectNumber"
        case recordString = "recordString"
        case fontSize = "fontSize"
        
        case isTimed = "timed"
    }
    
    class var subjectNumber: Int? {
        get {
            return get(storeKeys.subjectNumber.rawValue) as? Int
        }
        set {
            set(newValue, forKey: storeKeys.subjectNumber.rawValue)
        }
    }
    
    class var currentPerson: String? {
        get {
            return get(storeKeys.currentPerson.rawValue) as? String
        }
        set {
            set(newValue, forKey: storeKeys.currentPerson.rawValue)
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
    
    class var currentTitle: String? {
        get {
            return get(storeKeys.currentTitle.rawValue) as? String
        }
        set {
            set(newValue, forKey: storeKeys.currentTitle.rawValue)
        }
    }
    
    
    class var currentTime: Double? {
        get {
        return get(storeKeys.currentTime.rawValue) as? Double
        }
        set {
            set(newValue, forKey: storeKeys.currentTime.rawValue)
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
    
    class var recordString: String? {
        get {
        return get(storeKeys.recordString.rawValue) as? String
        }
        set {
            set(newValue, forKey: storeKeys.recordString.rawValue)
        }
    }
    
    class var fontSize: CGFloat? {
        get {
            return get(storeKeys.fontSize.rawValue) as? CGFloat
        }
        set {
            set(newValue, forKey: storeKeys.fontSize.rawValue)
        }
    }
    
    class var isTimed: Bool? {
        get {
            return get(storeKeys.isTimed.rawValue) as? Bool
        }
        set {
            set(newValue, forKey: storeKeys.isTimed.rawValue)
        }
    }
}