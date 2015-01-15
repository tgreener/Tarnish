//
//  Terrain.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol TerrainSpace {
    
}

class Terrain : TerrainSpace {
    let sprite : SKSpriteNode
    let blocksPathing : Bool
    
    init(texture: SKTexture, blocksPathing: Bool = false) {
        self.blocksPathing = blocksPathing
        sprite = SKSpriteNode(texture: texture)
        sprite.blendMode = SKBlendMode.Alpha
        sprite.anchorPoint = CGPointZero
        sprite.setScale(2)
    }
}
