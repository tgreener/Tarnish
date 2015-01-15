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
}

class EntityFactoryImpl : EntityFactory {
    let graphics : GraphicsFactory
    let map: GameMapImpl
    
    init(graphics: GraphicsFactory, map: GameMapImpl) {
        self.graphics = graphics
        self.map = map
    }

    func createBeardling() -> Entity {
        return EntityBuilder.entity()
            .with(exampleComponent  : ExampleComponent())
            .with(graphicsComponent : self.graphics.createRegularBeardlingGraphic())
            .with(positionComponent : PositionComponentImpl(map: self.map))
            .with(physicalComponent : PhysicalComponentImpl(blocksPathing: true))
            .with(characterComponent: nil)
            .create()
    }
    
    func createBraidling() -> Entity {
        return EntityBuilder.entity()
            .with(exampleComponent  : ExampleComponent())
            .with(graphicsComponent : self.graphics.createRegularBraidlingGraphic())
            .with(positionComponent : PositionComponentImpl(map: self.map))
            .with(physicalComponent : PhysicalComponentImpl(blocksPathing: true))
            .with(characterComponent: nil)
            .create()
    }
    
    func createNormalHouseBright() -> Entity {
        return EntityBuilder.entity()
            .with(exampleComponent  : ExampleComponent())
            .with(graphicsComponent : self.graphics.createBuildingGraphic(BuildingTextureTypes.HouseNormalOrangeBright))
            .with(positionComponent : PositionComponentImpl(map: self.map))
            .with(physicalComponent : PhysicalComponentImpl(blocksPathing: true))
            .create()
    }
}

class EntityBuilder {
    var example  : ExampleComponent?
    var graphic  : GraphicsComponent?
    var position : PositionComponent?
    var physical : PhysicalComponent?
    var character: CharacterComponent?
    
    class func entity() -> EntityBuilder {
        return EntityBuilder()
    }
    
    func with(exampleComponent ex: ExampleComponent) -> EntityBuilder{
        example = ex
        return self
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
    
    func validate() -> Bool {
        return example != nil && graphic != nil && position != nil && physical != nil
    }
    
    func create() -> Entity {
        assert(validate(), "Entity validation failed!")
        return Entity(exampleComponent: example!, graphics: graphic!, position: position!, physical: physical!, character: character)
    }
}
