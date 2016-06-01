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
    var braidlingTextures : [BeardlingTextureType: SKTexture] = [BeardlingTextureType: SKTexture]()
    
    let beardlingSheetWidth : UInt = 64
    let beardlingSheetHeight: UInt = 32
    let beardlingSpriteDimension : UInt = 16
    let beardlingAtlasPositions : [BeardlingTextureType: CGRect]
    let braidlingAtlasPositions : [BeardlingTextureType: CGRect]
    
    init() {
        let beardlingIdle1Rect = spriteSheetRect(0, y: 1, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        let beardlingIdle2Rect = spriteSheetRect(1, y: 1, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        let beardlingRun1Rect  = spriteSheetRect(2, y: 1, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        let beardlingRun2Rect  = spriteSheetRect(3, y: 1, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        
        beardlingAtlasPositions = [
            BeardlingTextureType.Idle1 : beardlingIdle1Rect,
            BeardlingTextureType.Idle2 : beardlingIdle2Rect,
            BeardlingTextureType.Run1  : beardlingRun1Rect,
            BeardlingTextureType.Run2  : beardlingRun2Rect
        ]
        
        let braidlingIdle1Rect = spriteSheetRect(0, y: 0, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        let braidlingIdle2Rect = spriteSheetRect(1, y: 0, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        let braidlingRun1Rect  = spriteSheetRect(2, y: 0, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        let braidlingRun2Rect  = spriteSheetRect(3, y: 0, dimension: beardlingSpriteDimension, sheetWidth: beardlingSheetWidth, sheetHeight: beardlingSheetHeight)
        
        braidlingAtlasPositions = [
            BeardlingTextureType.Idle1 : braidlingIdle1Rect,
            BeardlingTextureType.Idle2 : braidlingIdle2Rect,
            BeardlingTextureType.Run1  : braidlingRun1Rect,
            BeardlingTextureType.Run2  : braidlingRun2Rect
        ]
    }
    
    func createRegularBeardlingGraphic() -> BeardlingGraphicComponent {
        let result = BeardlingGraphicComponent(beardlingTextures: self.beardlingTextures)
        return result
    }
    
    func createRegularBraidlingGraphic() -> BeardlingGraphicComponent {
        let result = BraidlingGraphicComponent(beardlingTextures: self.braidlingTextures)
        return result
    }
    
    func loadBeardlingAtlas() {
        self.beardlingAtlas = SKTexture(imageNamed: "beardling_sheet_v3.png")
    }
    
    func loadBeardlingTextures() {
        if let atlas = self.beardlingAtlas {
            for (type, rect) in beardlingAtlasPositions {
                let texture = SKTexture(rect: rect, inTexture: atlas)
                beardlingTextures[type] = texture
                texture.filteringMode = SKTextureFilteringMode.Nearest
            }
            
            for (type, rect) in braidlingAtlasPositions {
                let texture = SKTexture(rect: rect, inTexture: atlas)
                braidlingTextures[type] = texture
                texture.filteringMode = SKTextureFilteringMode.Nearest
            }
        }
    }
}