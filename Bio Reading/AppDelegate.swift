//
//  AppDelegate.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 2/4/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

import Parse
import Bolts

import Fabric
import Crashlytics

//let appDel = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Fabric.with([Crashlytics()])
        
        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("fwjDaMY0iDqG90cgJRaWSjuizBEE9QgUeEvZluFh", clientKey: "DXlE0tdlqsoIiqbwVQnsQdZzU8SQIASaiqLbThwV")
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        UserStore.bios = UserStore.generateRandomBios()
        UserStore.bios.insert(("Practice Connecticut", false), atIndex: 1)
        UserStore.bios.insert(("Practice Rhode Island", true), atIndex: 0)
        
        
        UserStore.subjectNumber = nil
        UserStore.fontSize = 32
        UserStore.rTCond = arc4random_uniform(2) == 1 ? RTCond.Increasing : RTCond.Decreasing
        UserStore.timeLimit = 5*60
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

