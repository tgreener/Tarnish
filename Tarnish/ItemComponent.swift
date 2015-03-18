//
//  ItemComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/22/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class ItemComponent : FoodItem {
    let foodComponent : FoodItemComponent?
    weak var position : PositionComponent!
    
    init(food: FoodItemComponent?, position: PositionComponent? = nil) {
        foodComponent = food
        self.position = position
    }
    
    func isFood() -> Bool {
        return self.foodComponent != nil
    }
    
    func foodValue() -> Float {
        if isFood() {
            return foodComponent!.value
        }
        else { return 0.0 }
    }
    
    func eatValue(time: NSTimeInterval) -> Float {
        if isFood() {
            return min(foodComponent!.value, (foodComponent!.value / Float(foodComponent!.consumptionTime)) * Float(time))
        }
        else { return 0.0 }
    }
}
