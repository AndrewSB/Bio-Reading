//
//  UIFontExtension.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 7/6/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

extension UIFont {
    
    class func HelveticaNeue(size: CGFloat = UserStore.get("fontSize") as! CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
    
}