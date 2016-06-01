//
//  ItemManager.swift
//  Tarnish
//
//  Created by Todd Greener on 2/4/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class ItemManager {
    let ItemOperationQueue : NSOperationQueue = NSOperationQueue()
    var container : [ItemComponent] = [ItemComponent]()
    
    func add(item i: ItemComponent) {
        self.container.append(i)
    }
    
    func remove(item i: ItemComponent) {
        self.container = filter(over: { item in return item !== i })
    }
    
    func filter(over closure: (ItemComponent)->Bool) -> [ItemComponent] {
        return self.container.filter(closure)
    }
    
    func getClosest(to position: MapPosition, given closure: (ItemComponent)->Bool) -> ItemComponent? {
        let items = filter(over: closure)
        let closestDistance = Double.infinity
        var closestItem : ItemComponent? = nil
        for item in items {
            if (position.distanceSquaredTo(item.position.mapPosition) < closestDistance) {
                closestItem = item
            }
        }
        
        return closestItem
    }
}

