//
//  Entity.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol Updatable {
    func update() -> Void
}

protocol EntityContainer {
    func insertEntity(e: Entity) -> Void
    func removeEntity() -> Void
    func containsEntity() -> Bool
    func getEntity() -> Entity?
}

class Entity : Updatable{
    let exampleComponent : ExampleComponent
    let graphics : GraphicsComponent
    let position : PositionComponent!
    
    init(exampleComponent : ExampleComponent, graphics: GraphicsComponent, position: PositionComponent) {
        self.exampleComponent = exampleComponent
        self.graphics = graphics
        self.position = position
        self.position.entity = self
        
        self.graphics.addListener(self.exampleComponent)
        self.position.addListener(self.graphics)
    }
    
    func update() -> Void {
        
    }
}
