//
//  EntityFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol EntityFactory {
    func createBeardling() -> Entity
    func createBraidling() -> Entity
    func createNormalHouseBright() -> Entity
    func createApple() -> Entity
}

class EntityFactoryImpl : EntityFactory {
    let graphics : GraphicsFactory
    let map: GameMapImpl
    let items: ItemFactory
    
    init(graphics: GraphicsFactory, map: GameMapImpl, items: ItemFactory) {
        self.graphics = graphics
        self.map = map
        self.items = items
    }
    
    func createCharacter(graphics : BeardlingGraphicComponent) -> Entity {
        let position = PositionComponentImpl(map: self.map)
        let ai = AIComponentImpl(map: self.map, positionComponent: position)
        position.addListener(ai)
        ai.addListener(graphics)
        
        return EntityBuilder.entity()
            .with(graphicsComponent : graphics)
            .with(positionComponent : position)
            .with(physicalComponent : PhysicalComponentImpl(blocksPathing: true))
            .with(characterComponent: CharacterComponentImpl())
            .with(aiComponent: ai)
            .create()
    }

    func createBeardling() -> Entity {
        return createCharacter(self.graphics.createRegularBeardlingGraphic())
    }
    
    func createBraidling() -> Entity {
        return createCharacter(self.graphics.createRegularBraidlingGraphic())
    }
    
    func createNormalHouseBright() -> Entity {
        return EntityBuilder.entity()
            .with(graphicsComponent : self.graphics.createBuildingGraphic(BuildingTextureTypes.HouseNormalOrangeBright))
            .with(positionComponent : PositionComponentImpl(map: self.map))
            .with(physicalComponent : PhysicalComponentImpl(blocksPathing: true))
            .create()
    }
    
    func createApple() -> Entity {
        return EntityBuilder.entity()
            .with(graphicsComponent: graphics.createItemGraphic(ItemTextureType.Apple))
            .with(positionComponent: PositionComponentImpl(map: self.map))
            .with(physicalComponent: PhysicalComponentImpl(blocksPathing: false))
            .with(itemComponet: items.createApple())
            .create()
    }
}

class EntityBuilder {
    var graphic  : GraphicsComponent?
    var position : PositionComponent?
    var physical : PhysicalComponent?
    var character: CharacterComponent?
    var ai       : AIComponent?
    var item     : ItemComponent?
    
    class func entity() -> EntityBuilder {
        return EntityBuilder()
    }
    
    func with(graphicsComponent g:GraphicsComponent) -> EntityBuilder {
        graphic = g
        return self
    }
    
    func with(positionComponent p: PositionComponent) -> EntityBuilder {
        position = p
        return self
    }
    
    func with(physicalComponent p: PhysicalComponent) -> EntityBuilder {
        physical = p
        return self
    }
    
    func with(characterComponent c: CharacterComponent?) -> EntityBuilder {
        character = c
        return self
    }
    
    func with(aiComponent a: AIComponent) -> EntityBuilder {
        ai = a
        return self
    }
    
    func with(itemComponet i: ItemComponent) -> EntityBuilder {
        item = i
        return self
    }
    
    func validate() -> Bool {
        return graphic != nil && position != nil && physical != nil
    }
    
    func create() -> Entity {
        assert(validate(), "Entity validation failed!")
        return Entity(graphics: graphic!, position: position!, physical: physical!, character: character, ai: ai, item: item)
    }
}
