//
//  CoreDataHelper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 5/12/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation
import CoreData

extension NSEntityDescription {
    class func getNewRecordInManagedContext() -> Record {
        return NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: appDel.managedObjectContext!) as! Record
    }
}