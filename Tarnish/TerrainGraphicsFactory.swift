//
//  TerrainGraphicsFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

enum TerrainTextureType {
    case GrassEmpty
    case GrassDecoration1
    case GrassDecoration2
    case GrassShadedEmpty
    case GrassShadedDecoration1
    case GrassShadedDecoration2
}

class TerrainGraphicsFactory {
    var terrainAtlas            : SKTexture!
    let terrainAtlasPositions   : [TerrainTextureType: CGRect]
    var terrainTextures         : [TerrainTextureType: SKTexture] = [TerrainTextureType: SKTexture]()
    
    let terrainSheetWidth       : UInt = 256
    let terrainSheetHeight      : UInt = 256
    let terrainTextureDimension : UInt = 8
    let totalTextures           : UInt = 2
    
    init() {
        let grassEmptyRect       = spriteSheetRect(0, 31, terrainTextureDimension, terrainSheetWidth, terrainSheetHeight)
        let grassDecoration1Rect = spriteSheetRect(1, 31, terrainTextureDimension, terrainSheetWidth, terrainSheetHeight)
        
        terrainAtlasPositions = [
            TerrainTextureType.GrassEmpty       : grassEmptyRect,
            TerrainTextureType.GrassDecoration1 : grassDecoration1Rect
        ]
    }
    
    func loadAtlas() {
        terrainAtlas = SKTexture(imageNamed: "micro_tileset.png")
    }
    
    func loadTerrain() {
        if let atlas = self.terrainAtlas {
            var count : UInt = 0
            for (type, rect) in terrainAtlasPositions {
                let texture = SKTexture(rect: rect, inTexture: atlas)
                terrainTextures[type] = texture
                texture.filteringMode = SKTextureFilteringMode.Nearest
                count += 1
                notify({ listener in listener.terrainTextureLoaded(count, ofTotal: self.totalTextures) })
            }
        }
    }
    
    var listeners : [TerrainLoadListener] = [TerrainLoadListener]()
    
    func addListener(listener: TerrainLoadListener) {
        listeners.append(listener)
    }
    
    func notify(closure: (TerrainLoadListener) -> Void) {
        for listener in listeners {
            closure(listener)
        }
    }
}

protocol TerrainLoadListener {
    func terrainTextureLoaded(number: UInt, ofTotal: UInt) -> Void
}
