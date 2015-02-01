//
//  ItemFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/30/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class ItemFactory {
    func createApple() -> ItemComponent {
        let foodComponent : FoodItemComponent = FoodItemComponent(val: 10, time: 5)
        return ItemComponent(food: foodComponent)
    }
}
