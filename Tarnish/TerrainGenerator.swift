//
//  TerrainGenerator.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class TerrainGenerator {
    let terrainGraphics : TerrainGraphicsFactory
    
    init(graphics: TerrainGraphicsFactory) {
        terrainGraphics = graphics
    }
    
    func generateTerrainSpace() -> Terrain {
        let count : UInt = UInt(terrainGraphics.terrainTextures.count)
        let randomIndex = Int(random(0, count))
        let texture = terrainGraphics.terrainTextures.values.array[randomIndex]
        return Terrain(texture: texture)
    }
}
