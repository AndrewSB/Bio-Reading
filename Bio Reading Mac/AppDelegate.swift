//
//  AppDelegate.swift
//  Bio Reading Mac
//
//  Created by Andrew Breckenridge on 6/18/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Cocoa

import Bolts
import ParseOSX

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("fwjDaMY0iDqG90cgJRaWSjuizBEE9QgUeEvZluFh", clientKey: "DXlE0tdlqsoIiqbwVQnsQdZzU8SQIASaiqLbThwV")

        PFAnalytics.trackAppOpenedWithLaunchOptions(nil)
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

