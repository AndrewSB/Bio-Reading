//
//  GenericWrapper.swift
//  Bio Reading
//
//  Created by Andrew Breckenridge on 4/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import Foundation

class GenericWrapper<T> {
    let element : T
    init(element : T) {
        self.element = element
    }
}