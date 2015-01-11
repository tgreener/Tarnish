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
}

class EntityFactoryImpl : EntityFactory {
    let graphics : GraphicsFactory
    let map: GameMapImpl
    
    init(graphics: GraphicsFactory, map: GameMapImpl) {
        self.graphics = graphics
        self.map = map
    }

    func createBeardling() -> Entity {
        let example : ExampleComponent = ExampleComponent()
        let graphic : GraphicsComponent = self.graphics.createRegularBeardlingGraphic()
        let position: PositionComponent = PositionComponentImpl(map: self.map)
        
        return Entity(exampleComponent: example, graphics: graphic, position: position)
    }
}
