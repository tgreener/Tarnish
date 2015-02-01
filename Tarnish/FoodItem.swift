//
//  ItemProtocols.swift
//  Tarnish
//
//  Created by Todd Greener on 1/29/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol FoodItem {
    func isFood() -> Bool
    func foodValue() -> Float
    func eatValue(time: NSTimeInterval) -> Float
}

class FoodItemComponent {
    let value : Float
    let consumptionTime : NSTimeInterval
    
    init(val : Float, time : NSTimeInterval) {
        value = val
        consumptionTime = time
    }
}
