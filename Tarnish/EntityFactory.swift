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
    
    func createCharacter(graphics : BeardlingGraphicComponent) -> Entity {
        let position = PositionComponentImpl(map: self.map)
        let ai = AIComponentImpl(map: self.map, positionComponent: position)
        position.addListener(ai)
        graphics.addListener(ai)
        ai.addListener(graphics)
        
        return EntityBuilder.entity()
            .with(exampleComponent  : ExampleComponent())
            .with(graphicsComponent : graphics)
            .with(positionComponent : position)
            .with(physicalComponent : PhysicalComponentImpl(blocksPathing: true))
            .with(characterComponent: nil)
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
    var ai       : AIComponent?
    
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
    
    func with(aiComponent a: AIComponent) -> EntityBuilder {
        ai = a
        return self
    }
    
    func validate() -> Bool {
        return example != nil && graphic != nil && position != nil && physical != nil
    }
    
    func create() -> Entity {
        assert(validate(), "Entity validation failed!")
        return Entity(exampleComponent: example!, graphics: graphic!, position: position!, physical: physical!, character: character, ai: ai)
    }
}
