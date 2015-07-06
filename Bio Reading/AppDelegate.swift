//
//  AppDelegate.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Parse
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("fwjDaMY0iDqG90cgJRaWSjuizBEE9QgUeEvZluFh", clientKey: "DXlE0tdlqsoIiqbwVQnsQdZzU8SQIASaiqLbThwV")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        setupDefaults()
        
        return true
    }
    
    private func setupDefaults() {
        UserStore.bios = UserStore.generateRandomBios()
        UserStore.bios.insert(("Practice Connecticut", false), atIndex: 1)
        UserStore.bios.insert(("Practice Rhode Island", true), atIndex: 0)
        
        UserStore.subjectNumber = nil
        UserStore.fontSize = 32
        UserStore.rTCond = arc4random_uniform(2) == 1 ? RTCond.Increasing : RTCond.Decreasing
        UserStore.timeLimit = 5*60
    }
}