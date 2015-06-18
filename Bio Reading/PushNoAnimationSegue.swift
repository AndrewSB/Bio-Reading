//
//  PushNoAnimationSegue.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 6/17/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit
@objc(PushNoAnimationSegue)


class PushNoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let source = sourceViewController as! UIViewController
        if let navigation = source.navigationController {
            navigation.pushViewController(destinationViewController as! UIViewController, animated: false)
        } else {
            println("navigation is not source navigation controller")
        }
    }
}
