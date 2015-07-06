//
//  NSUserDefaultHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

class UserStore {

    static let set = NSUserDefaults.standardUserDefaults().setObject
    static let get = NSUserDefaults.standardUserDefaults().objectForKey
    
    enum storeKeys: String {
        case subjectNumber = "subjectNumber"
        case timeLimit = "timeLimit"
        
        case currentPerson = "currentPerson"
        case currentBio = "currentBio"
        case currentTitle = "currentTitle"
        case currentTime = "currentTime"
        case currentFamiliarity = "currentFamiliarity"
        
        case rTCond = "rTCond"
        case timeOffset = "timeOffset"
        
        case bios = "bios"
        case fontSize = "fontSize"
        
        case isTimed = "timed"
        
        case parseClassNames = "parseClassNames"
    }
    
    class var subjectNumber: Int? {
        get {
            return get(storeKeys.subjectNumber.rawValue) as? Int
        }
        set {
            set(newValue, forKey: storeKeys.subjectNumber.rawValue)
        }
    }
    
    class var timeLimit: Int? {
        get {
        return get(storeKeys.timeLimit.rawValue) as? Int
        }
        set {
            set(newValue, forKey: storeKeys.timeLimit.rawValue)
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
    
    class var currentFamiliarity: Double? {
        get {
            return get(storeKeys.currentFamiliarity.rawValue) as? Double
        }
        set {
            set(newValue, forKey: storeKeys.currentFamiliarity.rawValue)
        }
    }
    
    class var rTCond: RTCond? {
        get {
            let input = get(storeKeys.rTCond.rawValue) as? Int
            if let input = input {
                return RTCond(rawValue: input)
            }
            return nil
        }
        set {
            set(newValue!.hashValue, forKey: storeKeys.rTCond.rawValue)
        }
    }
    
    class var timeOffset: Int? {
        get {
            return get(storeKeys.timeOffset.rawValue) as? Int
        }
        set {
            set(newValue, forKey: storeKeys.timeOffset.rawValue)
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
    
    class var parseClassName: Set<String> {
        get {
            if let arr = get(storeKeys.parseClassNames.rawValue) as? [String] {
                return Set(arr)
            } else {
                return Set<String>()
            }
        }
        set {
            set(Array(newValue), forKey: storeKeys.parseClassNames.rawValue)
        }
    }
    
}