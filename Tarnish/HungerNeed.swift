//
//  HungerNeed.swift
//  Tarnish
//
//  Created by Todd Greener on 1/29/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class HungerNeed : Need {
    let baseDegradeRate : Float = 1.0
    var value           : Float = MaxNeedValues.Hunger
    
    func update(dt: NSTimeInterval) {
        value = max(0.0, self.value - (Float(dt) * baseDegradeRate))
    }
    
    func feed(valueAmount: Float) {
        value = min(MaxNeedValues.Hunger, self.value + valueAmount)
    }
}
