//
//  Map.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol GameMap {
    func mapSpaceAt(x : UInt, y : UInt, z : UInt) -> MapSpace
    func addMapTo(scene: SKScene) -> Void
    func convertToMapNodeSpace(mapPosition: MapPosition) -> CGPoint
}

class GameMapImpl : GameMap {
    var container : [MapSpace]
    let size : UInt
    let mapNode : MapNode = MapNode()
    let mapSpacePixelCount : UInt = 16
    
    init(size : UInt) {
        self.size = size
        let intSize : Int = Int(size)
        container = [MapSpace]()
        container.reserveCapacity(intSize * intSize * intSize)
        
        for var z : UInt = 0; z < size; z++ {
            for var y : UInt = 0; y < size; y++ {
                for var x : UInt = 0; x < size; x++ {
                    let position : MapPosition = MapPosition(x: x, y: y, z: z)
                    self.container.append(MapSpace(position: position, mapNode: self.mapNode))
                }
            }
        }

        mapNode.setScale(2)
    }
    
    func getArrayIndex(position: MapPosition) -> Int {
        return getArrayIndex(position.x, y: position.y, z: position.z)
    }
    
    func getArrayIndex(x: UInt, y: UInt, z: UInt) -> Int {
        return Int(x + (y * size) + (z * (size * size)))
    }
    
    func mapSpaceAt(position: MapPosition) -> MapSpace {
        return mapSpaceAt(position.x, y: position.y, z: position.z)
    }
    
    func mapSpaceAt(x: UInt, y: UInt, z : UInt) -> MapSpace {
        assert(x < size && y < size && z < size, "Tried to access space out of map bounds")
        return self.container[getArrayIndex(x, y: y, z: z)];
    }
    
    func addMapTo(scene: SKScene) -> Void {
        let pos = CGPoint(x: 0, y: 0)
        self.mapNode.position = pos
        scene.addChild(self.mapNode)
    }
    
    func convertToMapNodeSpace(mapPosition: MapPosition) -> CGPoint {
        let x : CGFloat = CGFloat(mapPosition.x) * CGFloat(self.mapSpacePixelCount)
        let y : CGFloat = CGFloat(mapPosition.y) * CGFloat(self.mapSpacePixelCount)
        
        return CGPoint(x: x, y: y)
    }
}

class MapNode : SKNode {

}
