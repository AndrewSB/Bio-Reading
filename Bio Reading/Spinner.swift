//
//  Spinner.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 7/7/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    convenience init(view: UIView) {
        self.init(activityIndicatorStyle: .Gray)
        self.center = view.center
        self.startAnimating()
    }

}
