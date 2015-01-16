//
//  PlayScene.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class PlayScene : BaseScene {
    let mapSize : UInt = 8 // 64 should be max map size, I think
    var map : GameMap!
    var graphicsFactory : GraphicsFactory!
    var entityFactory : EntityFactory!
    
    var beardling : Entity!
    var braidling : Entity!
    
    var previousTime : NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
    }
    
    override func createSceneContents() {
        super.createSceneContents()
        loadData()
        
        self.map.addMapTo(self)
        
        beardling = entityFactory.createBeardling()
        beardling.position.setTo(MapPosition(x: 0, y: 0, z: 0))
        braidling = entityFactory.createBraidling()
        braidling.position.setTo(MapPosition(x: 0, y: mapSize - 1, z: 0))
        
        let building = entityFactory.createNormalHouseBright()
        building.position.setTo(MapPosition(x: mapSize / 2, y: mapSize / 2, z: 0))
        
        let building2 = entityFactory.createNormalHouseBright()
        building2.position.setTo(MapPosition(x: mapSize / 3, y: mapSize / 3, z: 0))
        
        let building3 = entityFactory.createNormalHouseBright()
        building3.position.setTo(MapPosition(x: mapSize / 5, y: mapSize / 5, z: 0))
        
        var previousTime = CFAbsoluteTimeGetCurrent()
    }
    
    override func update(currentTime: NSTimeInterval) {
        let dt = currentTime - previousTime
        if let ai = beardling.ai {
            ai.update(dt)
        }
        if let ai = braidling.ai {
            ai.update(dt)
        }
        previousTime = currentTime
    }
    
    func loadData() {
        let mapTextures      = SKTexture(imageNamed: "micro_tileset.png")
        let terrainFactory   = TerrainGraphicsFactory (atlas: mapTextures)
        let buildingFactory  = BuildingGraphicsFactory(atlas: mapTextures)
        let beardlingFactory = BeardlingGraphicsFactory()
        
        let terrainGenerator = TerrainGenerator(graphics: terrainFactory)
        
        graphicsFactory = GraphicsFactory(beardlingFactory: beardlingFactory, terrainFactory: terrainFactory, buildingFactory: buildingFactory)
        graphicsFactory.loadAllTextures()
        
        let mapImpl = GameMapImpl(size: mapSize, terrainGenerator: terrainGenerator)
        map = mapImpl
        
        entityFactory = EntityFactoryImpl(graphics: graphicsFactory, map: mapImpl)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        let braidX = braidling.position.mapPosition.x
//        let braidY = braidling.position.mapPosition.y
//        
//        if braidX < mapSize - 1 {
//            braidling.position.moveTo(MapPosition(x: braidX + 1, y: braidY, z: 0))
//        }
    }
}
