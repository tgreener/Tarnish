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
    let mapNode : MapNode

    init(size : UInt, terrainGenerator : TerrainGenerator) {
        self.size = size
        mapNode = MapNode(mapSize: self.size)
        
        let intSize : Int = Int(size)
        container = [MapSpace]()
        container.reserveCapacity(intSize * intSize * intSize)
        
        for var z : UInt = 0; z < size; z++ {
            for var y : UInt = 0; y < size; y++ {
                for var x : UInt = 0; x < size; x++ {
                    let position : MapPosition = MapPosition(x: x, y: y, z: z)
                    self.container.append(MapSpace(position: position, mapNode: self.mapNode))
                    if z == UInt(0) {
                        self.container[getArrayIndex(x, y: y, z: z)].terrain = terrainGenerator.generateTerrainSpace()
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
    
    func addMapTo(scene: SKScene) -> Void {
        let pos = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame))
        self.mapNode.position = pos
        self.mapNode.minimumScale = CGFloat(scene.frame.size.height) / CGFloat(self.mapNode.mapSpacePixelCount * self.size)
        self.mapNode.setScale(self.mapNode.minimumScale)
        
        scene.addChild(self.mapNode)
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
