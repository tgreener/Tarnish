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

class Entity : Updatable{
    let exampleComponent : ExampleComponent
    let graphics : GraphicsComponent
    let position : PositionComponent
    let character: CharacterComponent?
    
    init(exampleComponent : ExampleComponent,
         graphics: GraphicsComponent,
         position: PositionComponent,
         physical: PhysicalComponent,
         character: CharacterComponent?
        )
    {
        self.exampleComponent = exampleComponent
        self.character = character
        self.graphics = graphics
        self.position = position
        self.position.entity = self
        
        self.graphics.addListener(self.exampleComponent)
        self.position.addListener(self.graphics)
    }
    
    func update() -> Void {
        
    }
}
