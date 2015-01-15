//
//  GraphicsFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

func spriteSheetRect(x : UInt, y : UInt, dimension: UInt, sheetWidth: UInt, sheetHeight: UInt) -> CGRect {
    let floatSheetWidth = CGFloat(sheetWidth)
    let floatSheetHeight = CGFloat(sheetHeight)
    let floatDimension = CGFloat(dimension)
    
    let sheetPositionX : CGFloat = CGFloat(x) * floatDimension
    let sheetPositionY : CGFloat = CGFloat(y) * floatDimension
    let spriteSize = CGSize(width: floatDimension / floatSheetWidth, height: floatDimension / floatSheetHeight)
    let spriteOrigin = CGPoint(x: sheetPositionX / floatSheetWidth, y: sheetPositionY / floatSheetHeight)
    
    return CGRect(origin: spriteOrigin, size: spriteSize)
}


class GraphicsFactory {
    // Load methods
    func loadAllTextures() {
        beardlingFactory.loadBeardlingAtlas()
        beardlingFactory.loadBeardlingTextures()
        
        terrainFactory.loadTerrain()
        buildingFactory.loadBuildings()
    }
    
    func createRegularBeardlingGraphic() -> BeardlingGraphicComponent {
        return beardlingFactory.createRegularBeardlingGraphic();
    }
    
    func createRegularBraidlingGraphic() -> BeardlingGraphicComponent {
        return beardlingFactory.createRegularBraidlingGraphic()
    }
    
    func createBuildingGraphic(type: BuildingTextureTypes) -> BuildingGraphicComponent {
        return buildingFactory.createBuildingGraphic(type)
    }
    
    let beardlingFactory : BeardlingGraphicsFactory
    let terrainFactory   : TerrainGraphicsFactory
    let buildingFactory   : BuildingGraphicsFactory
    
    init(beardlingFactory: BeardlingGraphicsFactory, terrainFactory: TerrainGraphicsFactory, buildingFactory: BuildingGraphicsFactory) {
        self.beardlingFactory = beardlingFactory
        self.terrainFactory = terrainFactory
        self.buildingFactory = buildingFactory
    }
}
