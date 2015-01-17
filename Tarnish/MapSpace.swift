//
//  MapSpace.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit



struct MapSpace {
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
    
    mutating func insertEntity(e: Entity) -> Void {
        self.entity = e
        if(e.graphics.getNode().parent !== self.mapNode) {
            e.graphics.getNode().zPosition = 1
            e.graphics.addTo(self.mapNode)
        }
    }
    
    mutating func removeEntity() -> Void {
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
    
    func isPathable() -> Bool {
        var result : Bool = false
        
        if let entity = self.entity {
            result = result || (!entity.physics.blocksPathing && !self.terrain.blocksPathing)
        }
        else {
            result = result || !self.terrain.blocksPathing
        }
        
        return result
    }
}

struct MapPosition : Equatable, Hashable, Printable {
    let x : UInt
    let y : UInt
    let z : UInt
    let hashValue: Int
    let description: String
    
    init(x: UInt, y: UInt, z: UInt) {
        self.x = x
        self.y = y
        self.z = z
        hashValue = 0
        hashValue = hashValue | Int(x)
        hashValue = hashValue | (Int(y) << 10)
        hashValue = hashValue | (Int(z) << 20)
        
        description = "Map Position: (\(x), \(y), \(z))"
    }
    
    init(position: MapPosition) {
        self.init(x: position.x, y: position.y, z:position.z)
    }
    
    func distanceSquaredTo(position: MapPosition) -> Double {
        let signedX = Int(x)
        let signedY = Int(y)
        let signedZ = Int(z)
        
        let otherSignedX = Int(position.x)
        let otherSignedY = Int(position.y)
        let otherSignedZ = Int(position.z)

        let result = pow(Double(signedX - otherSignedX), 2) + pow(Double(signedY - otherSignedY), 2) + pow(Double(signedZ - otherSignedZ), 2)
        return result
    }
}


func ==(lhs: MapPosition, rhs: MapPosition) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}
