//
//  BeardlingGraphicsFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

enum BeardlingTextureType {
    case Idle1
    case Idle2
    case Run1
    case Run2
}

class BeardlingGraphicsFactory {
    var beardlingAtlas : SKTexture!
    var beardlingTextures : [BeardlingTextureType: SKTexture] = [BeardlingTextureType: SKTexture]()
    
    let beardlingSheetWidth : UInt = 64
    let beardlingSheetHeight: UInt = 16
    let beardlingSpriteDimension : UInt = 16
    let beardlingAtlasPositions : [BeardlingTextureType: CGRect]
    
    init() {
        let idle1Rect = spriteSheetRect(0, 0, beardlingSpriteDimension, beardlingSheetWidth, beardlingSheetHeight)
        let idle2Rect = spriteSheetRect(1, 0, beardlingSpriteDimension, beardlingSheetWidth, beardlingSheetHeight)
        let run1Rect  = spriteSheetRect(2, 0, beardlingSpriteDimension, beardlingSheetWidth, beardlingSheetHeight)
        let run2Rect  = spriteSheetRect(3, 0, beardlingSpriteDimension, beardlingSheetWidth, beardlingSheetHeight)
        
        beardlingAtlasPositions = [
            BeardlingTextureType.Idle1 : idle1Rect,
            BeardlingTextureType.Idle2 : idle2Rect,
            BeardlingTextureType.Run1  : run1Rect,
            BeardlingTextureType.Run2  : run2Rect
        ]
    }
    
    func createRegularBeardlingGraphic() -> BeardlingGraphicComponent {
        let result = BeardlingGraphicComponent(beardlingTextures: self.beardlingTextures)
        result.anchorPoint = CGPoint(x: 0, y: 0)
        return result;
    }
    
    func loadBeardlingAtlas() {
        self.beardlingAtlas = SKTexture(imageNamed: "beardling_sheet.png")
    }
    
    func loadBeardlingTextures() {
        if let atlas = self.beardlingAtlas {
            for (type, rect) in beardlingAtlasPositions {
                let texture = SKTexture(rect: rect, inTexture: atlas)
                beardlingTextures[type] = texture
                texture.filteringMode = SKTextureFilteringMode.Nearest
            }
        }
    }
}