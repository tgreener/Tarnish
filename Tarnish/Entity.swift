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
    
    init(exampleComponent : ExampleComponent, graphics: GraphicsComponent) {
        self.exampleComponent = exampleComponent
        self.graphics = graphics
        
        self.graphics.addListener(self.exampleComponent)
    }
    
    func update() -> Void {
        
    }
}
