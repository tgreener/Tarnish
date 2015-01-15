//
//  PlayScene.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class PlayScene : BaseScene {
    let mapSize : UInt = 10
    var map : GameMap!
    var graphicsFactory : GraphicsFactory!
    var entityFactory : EntityFactory!
    
    var beardling : Entity!
    var braidling : Entity!
    
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
    }
    
    override func update(currentTime: NSTimeInterval) {
        // Nope
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
        let beardX = beardling.position.mapPosition.x
        let beardY = beardling.position.mapPosition.y
        
        let braidX = braidling.position.mapPosition.x
        let braidY = braidling.position.mapPosition.y
        
        if beardX < mapSize - 1 && braidX < mapSize - 1 {
            beardling.position.moveTo(MapPosition(x: beardX + 1, y: beardY + 1, z: 0))
            braidling.position.moveTo(MapPosition(x: braidX + 1, y: braidY, z: 0))
        }
    }
}
