//
//  MapSpace.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol EntityContainer {
    func insertEntity(e: Entity) -> Void
    func removeEntity() -> Void
    func containsEntity() -> Bool
    func getEntity() -> Entity?
}

class MapSpace : EntityContainer {
    var entity : Entity?
    
    init() {
        self.entity = nil
    }
    
    func insertEntity(e: Entity) -> Void {
        self.entity = e
    }
    
    func removeEntity() -> Void {
        self.entity = nil
    }
    
    func containsEntity() -> Bool {
        return self.entity != nil
    }
    
    func getEntity() -> Entity? {
        return self.entity
    }
}
