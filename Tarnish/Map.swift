//
//  Map.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol GameMap : class {
    func mapSpaceAt(x : UInt, y : UInt, z : UInt) -> MapSpace
    func mapSpaceAt(position: MapPosition) -> MapSpace
    func insert(entity e: Entity, atPosition position: MapPosition) -> Void
    func removeEntity(entity: Entity, atPosition position: MapPosition) -> Void
    
    func addMapTo(scene: SKScene) -> Void
    func convertToMapNodeSpace(mapPosition: MapPosition) -> CGPoint
    func getPathableNeighbors(position: MapPosition) -> [MapPosition]
    
    var size : UInt { get }
}

class GameMapImpl : GameMap {
    var container : [MapSpace]
    let size : UInt
    let mapNode : MapNode

    init(size : UInt, terrainGenerator : TerrainGenerator) {
        // Capped to ensure all MapSpace hashes are unique (and performance, that big of a map is absurd!)
        if size > 1024 {
            self.size = 1024
        }
        else {
            self.size = size
        }
        
        mapNode = MapNode(mapSize: self.size)
        
        let intSize : Int = Int(size)
        let arraySize = intSize * intSize // intSize, for z levels
        container = [MapSpace](count: arraySize, repeatedValue: MapSpace(position: MapPosition(x: 0, y: 0, z: 0), mapNode: self.mapNode))
        
        for var z : UInt = 0; z < 1 /* size if I ever implement the z levels */; z += 1 {
            for var y : UInt = 0; y < size; y += 1 {
                for var x : UInt = 0; x < size; x += 1 {
                    let position : MapPosition = MapPosition(x: x, y: y, z: z)
                    self.container[getArrayIndex(position)] = MapSpace(position: position, mapNode: self.mapNode)
                    if z == UInt(0) {
                        self.container[getArrayIndex(position)].terrain = terrainGenerator.generateTerrainSpace()
                    }
                }
            }
        }
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
    
    func insert(entity e: Entity, atPosition position: MapPosition) {
        self.container[getArrayIndex(position)].insertEntity(e)
    }
    
    func removeEntity(entity: Entity, atPosition position: MapPosition) {
        self.container[getArrayIndex(position)].removeEntity(entity)
    }
    
    func addMapTo(scene: SKScene) -> Void {
        let pos = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame))
        self.mapNode.position = pos
        self.mapNode.minimumScale = CGFloat(scene.frame.size.height) / CGFloat(self.mapNode.mapSpacePixelCount * self.size)
        self.mapNode.setScale(self.mapNode.minimumScale)
        
        scene.addChild(self.mapNode)
    }
    
    func isPathablePosition(x: Int, y: Int, z: Int) -> Bool {
        if x < 0 || UInt(x) >= self.size { return false }
        if y < 0 || UInt(y) >= self.size { return false }
        if z < 0 || UInt(z) >= self.size { return false }

        return mapSpaceAt(UInt(x), y: UInt(y), z: UInt(z)).isPathable()
    }
    
    func getPathableNeighbors(position: MapPosition) -> [MapPosition] {
        var result = [MapPosition]()
        
        if isPathablePosition(Int(position.x) - 1, y: Int(position.y), z: Int(position.z)) {
            result.append(MapPosition(x: position.x - 1, y: position.y, z: position.z))
        }
        
        if isPathablePosition(Int(position.x) + 1, y: Int(position.y), z: Int(position.z)) {
            result.append(MapPosition(x: position.x + 1, y: position.y, z: position.z))
        }
        
        if isPathablePosition(Int(position.x), y: Int(position.y) - 1, z: Int(position.z)) {
            result.append(MapPosition(x: position.x, y: position.y - 1, z: position.z))
        }
        
        if isPathablePosition(Int(position.x), y: Int(position.y) + 1, z: Int(position.z)) {
            result.append(MapPosition(x: position.x, y: position.y + 1, z: position.z))
        }
        
        return result
    }
    
    func convertToMapNodeSpace(mapPosition: MapPosition) -> CGPoint {
        return mapNode.convertToMapNodeSpace(mapPosition)
    }
}

class MapNode : SKNode {
    let mapSpacePixelCount : UInt = 16
    var mapSize : UInt
    var minimumScale : CGFloat = 1.0
    
    init(mapSize: UInt) {
        self.mapSize = mapSize
        super.init()
    }
    
    override func setScale(scale: CGFloat) {
        if(scale >= minimumScale) {
            super.setScale(scale)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func convertToMapNodeSpace(mapPosition: MapPosition) -> CGPoint {
        let x : CGFloat = (CGFloat(mapPosition.x) - CGFloat(self.mapSize / 2)) * CGFloat(self.mapSpacePixelCount)
        let y : CGFloat = (CGFloat(mapPosition.y) - CGFloat(self.mapSize / 2)) * CGFloat(self.mapSpacePixelCount)
        
        return CGPoint(x: x, y: y)
    }
}
