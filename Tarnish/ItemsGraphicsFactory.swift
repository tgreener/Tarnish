//
//  ItemsGraphicsFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/24/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

enum ItemTextureType {
    case Cheese
    case Bread
    case Apple
}

class ItemGraphicsFactory {
    let itemRects : [ItemTextureType : CGRect] = [ItemTextureType : CGRect](minimumCapacity: 3)
    var itemTextures : [ItemTextureType : SKTexture] = [ItemTextureType : SKTexture](minimumCapacity: 3)
    let itemAtlas : SKTexture
    
    let atlasHeight : UInt = 16
    let atlasWidth  : UInt = 48
    let itemTextureDimension : UInt = 16
    
    init() {
        itemAtlas = SKTexture(imageNamed: "items.png")
        
        let cheeseRect : CGRect = spriteSheetRect(0, 0, itemTextureDimension, atlasWidth, atlasHeight)
        let breadRect  : CGRect = spriteSheetRect(1, 0, itemTextureDimension, atlasWidth, atlasHeight)
        let appleRect  : CGRect = spriteSheetRect(2, 0, itemTextureDimension, atlasWidth, atlasHeight)
        
        itemRects = [
            ItemTextureType.Cheese : cheeseRect,
            ItemTextureType.Bread  : breadRect,
            ItemTextureType.Apple  : appleRect
        ]
    }
    
    func loadItems() {
        for (type, rect) in itemRects {
            let texture = SKTexture(rect: rect, inTexture: itemAtlas)
            itemTextures[type] = texture
            texture.filteringMode = SKTextureFilteringMode.Nearest
        }
    }
    
    func createItemGraphic(type: ItemTextureType) -> GraphicsComponent {
        let tex = itemTextures[type]
        let result = GraphicNode(texture: tex)
        result.anchorPoint = CGPointZero
        result.setScale(0.5)
        result.zPosition = 0.5
        
        return result
    }
}
