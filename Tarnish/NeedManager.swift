//
//  NeedManager.swift
//  Tarnish
//
//  Created by Todd Greener on 1/29/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol Need {
    func update(dt: NSTimeInterval) -> Void
}

struct MaxNeedValues {
    static let Hunger : Float = 100.0
}

class NeedManager {
    let hunger : HungerNeed = HungerNeed()
    
    func update(dt :NSTimeInterval) -> Void {
        hunger.update(dt)
//        println("Hunger Value: \(hunger.value)")
    }
}
