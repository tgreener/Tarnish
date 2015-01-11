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
    
    override func createSceneContents() {
        super.createSceneContents()
        loadData()
        
        self.map.addMapTo(self)
        beardling = entityFactory.createBeardling()
        beardling.position.mapPosition = MapPosition(x: 0, y: 0, z: 0)
    }
    
    override func update(currentTime: NSTimeInterval) {
        // Nope
    }
    
    func loadData() {
        let mapImpl = GameMapImpl(size: mapSize)
        map = mapImpl
        
        let beardlingFactory = BeardlingGraphicsFactory()
        let terrainFactory = TerrainGraphicsFactory()
        graphicsFactory = GraphicsFactory(beardlingFactory: beardlingFactory, terrainFactory: terrainFactory)
        graphicsFactory.loadAllTextures()
        entityFactory = EntityFactoryImpl(graphics: graphicsFactory, map: mapImpl)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let currentX = beardling.position.mapPosition.x
        let currentY = beardling.position.mapPosition.y
        
        if currentX < mapSize - 1 {
            beardling.position.mapPosition = MapPosition(x: currentX + 1, y: currentY + 1, z: 0)
        }
    }
}
