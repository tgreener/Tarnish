//
//  BuildingGraphicsFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

enum BuildingTextureTypes {
    case HouseNormalOrangeBright
    case HouseNormalOrangeDark
    case HouseNormalGreyBright
    case HouseNormalGreyDark
    case HouseSnowOrangeBright
    case HouseSnowOrangeDark
    case HouseSnowGreyBright
    case HouseSnowGreyDark
    case TowerNormalTopBright
    case TowerNormalBottomBright
    case TowerNormalTopDark
    case TowerNormalBottomDark
    case TowerSnowTopBright
    case TowerSnowBottomBright
    case TowerSnowTopDark
    case TowerSnowBottomDark
}

class BuildingGraphicsFactory {
    let buildingRects    : [BuildingTextureTypes: CGRect] = [BuildingTextureTypes: CGRect](minimumCapacity: 16)
    var buildingTextures : [BuildingTextureTypes: SKTexture] = [BuildingTextureTypes: SKTexture](minimumCapacity: 16)
    let buildingAtlas  : SKTexture
    
    let terrainSheetWidth       : UInt = 256
    let terrainSheetHeight      : UInt = 256
    let terrainTextureDimension : UInt = 8
    
    init(atlas: SKTexture) {
        buildingAtlas = atlas
        let nnobRect = spriteSheetRect(26, 30, terrainTextureDimension, terrainSheetWidth, terrainSheetHeight)
        
        buildingRects = [
            BuildingTextureTypes.HouseNormalOrangeBright : nnobRect
        ]
    }
    
    func loadBuildings() {
        var count : UInt = 0
        let total : UInt = UInt(buildingRects.count)
        
        for (type, rect) in buildingRects {
            let texture = SKTexture(rect: rect, inTexture: self.buildingAtlas)
            buildingTextures[type] = texture
            texture.filteringMode = SKTextureFilteringMode.Nearest
            count += 1
            notify({ listener in listener.buildingTextureLoaded(count, ofTotal: total) })
        }
    }
    
    func createBuildingGraphic(type: BuildingTextureTypes) -> BuildingGraphicComponent {
        let tex : SKTexture = buildingTextures[type]!
        let result = BuildingGraphicComponent(texture: tex)
        result.anchorPoint = CGPointZero
        result.setScale(2)
        return result
    }
    
    var listeners : [BuildingLoadListener] = [BuildingLoadListener]()
    
    func addListener(listener: BuildingLoadListener) {
        listeners.append(listener)
    }
    
    func notify(closure: (BuildingLoadListener) -> Void) {
        for listener in listeners {
            closure(listener)
        }
    }
}

protocol BuildingLoadListener {
    func buildingTextureLoaded(number: UInt, ofTotal: UInt) -> Void
}