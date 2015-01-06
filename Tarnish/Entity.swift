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
    
    init(exampleComponent : ExampleComponent) {
        self.exampleComponent = exampleComponent
    }
    
    func update() -> Void {
        
    }
}
