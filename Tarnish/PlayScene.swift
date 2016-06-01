//
//  PlayScene.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class PlayScene : BaseScene {
    let mapSize : UInt = 64 // 64 should be max map size, I think
    var map : GameMap!
    var graphicsFactory : GraphicsFactory!
    var entityFactory : EntityFactory!
    
    var beardlings = [Entity]()
    let items = ItemManager()
    
    var previousTime : NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
    }
    
    override func createSceneContents() {
        super.createSceneContents()
        loadData()
        
        self.map.addMapTo(self)
        
        let beardling = entityFactory.createBeardling()
        beardling.position.setTo(MapPosition(x: 0, y: 0, z: 0))
        let beardling1 = entityFactory.createBeardling()
        beardling1.position.setTo(MapPosition(x: mapSize / 2, y: 0, z: 0))
        let beardling2 = entityFactory.createBeardling()
        beardling2.position.setTo(MapPosition(x: mapSize - 1, y: 0, z: 0))
        let braidling = entityFactory.createBraidling()
        braidling.position.setTo(MapPosition(x: 0, y: mapSize - 1, z: 0))
        let braidling1 = entityFactory.createBraidling()
        braidling1.position.setTo(MapPosition(x: mapSize / 2, y: mapSize - 1, z: 0))
        let braidling2 = entityFactory.createBraidling()
        braidling2.position.setTo(MapPosition(x: mapSize - 1, y: mapSize - 1, z: 0))
        
        beardlings.append(beardling)
//        beardlings.append(braidling)
//        beardlings.append(braidling1)
//        beardlings.append(braidling2)
//        beardlings.append(beardling1)
//        beardlings.append(beardling2)
        
        let apple = entityFactory.createApple()
        apple.position.setTo(MapPosition(x: mapSize / 2, y: mapSize - 1, z: 0))
        items.add(item: apple.item!)
        
        let building = entityFactory.createNormalHouseBright()
        building.position.setTo(MapPosition(x: mapSize / 2, y: mapSize / 2, z: 0))
        
        let building2 = entityFactory.createNormalHouseBright()
        building2.position.setTo(MapPosition(x: mapSize / 3, y: mapSize / 3, z: 0))
        
        let building3 = entityFactory.createNormalHouseBright()
        building3.position.setTo(MapPosition(x: mapSize / 5, y: mapSize / 5, z: 0))
        
        var previousTime = CFAbsoluteTimeGetCurrent()
    }
    
    override func update(currentTime: NSTimeInterval) {
        let dt = previousTime < 0 ? 0.0 : currentTime - previousTime
        
        // AI Loop
        var claims : [MapPosition : [PathStepper]] = [MapPosition : [PathStepper]]()
        for beardling in beardlings {
            if let ai = beardling.ai {
                ai.update(dt, claims: &claims)
            }
        }
        
        // Resolve conflicts.
        // TODO: Make this way better
        for (_, steppers) in claims {
            steppers[0].step()
            
            for var i = 1; i < steppers.count; i += 1 {
                steppers[i].stop()
            }
        }
        
        previousTime = currentTime
    }
    
    func loadData() {
        let mapTextures      = SKTexture(imageNamed: "micro_tileset.png")
        let terrainFactory   = TerrainGraphicsFactory (atlas: mapTextures)
        let terrainGenerator = TerrainGenerator(graphics: terrainFactory)
        let itemFactory = ItemFactory()
        
        graphicsFactory = GraphicsFactory(
            beardlingFactory: BeardlingGraphicsFactory(),
            terrainFactory: terrainFactory,
            buildingFactory: BuildingGraphicsFactory(atlas: mapTextures),
            itemsFactory: ItemGraphicsFactory())
        graphicsFactory.loadAllTextures()
        
        let mapImpl = GameMapImpl(size: mapSize, terrainGenerator: terrainGenerator)
        map = mapImpl
        
        entityFactory = EntityFactoryImpl(graphics: graphicsFactory, map: mapImpl, items: itemFactory)
        previousTime = -1.0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        let braidX = braidling.position.mapPosition.x
//        let braidY = braidling.position.mapPosition.y
//        
//        if braidX < mapSize - 1 {
//            braidling.position.moveTo(MapPosition(x: braidX + 1, y: braidY, z: 0))
//        }
    }
}
