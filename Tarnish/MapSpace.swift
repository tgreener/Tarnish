//
//  MapSpace.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit



class MapSpace {
    var entity : Entity?
    var terrain: Terrain! = nil {
        didSet {
            self.terrain.sprite.position = mapNode.convertToMapNodeSpace(position)
            mapNode.addChild(self.terrain.sprite)
            
            if oldValue != nil {
                oldValue.sprite.removeFromParent()
            }
        }
    }
    let position: MapPosition
    unowned let mapNode : MapNode
    
    init(position: MapPosition, mapNode: MapNode) {
        self.entity = nil
        self.position = position
        self.mapNode = mapNode
    }
    
    func insertEntity(e: Entity) -> Void {
        self.entity = e
        if(e.graphics.getNode().parent !== self.mapNode) {
            e.graphics.getNode().zPosition = 1
            e.graphics.addTo(self.mapNode)
        }
    }
    
    func removeEntity() -> Void {
        if let entity = self.entity {
            self.entity = nil
        }
    }
    
    func containsEntity() -> Bool {
        return self.entity != nil
    }
    
    func getEntity() -> Entity? {
        return self.entity
    }
}
