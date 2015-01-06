//
//  ExampleComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class ExampleComponent : GraphicsComponentListener{
    
    func graphicWasAddedToScene(graphic: GraphicsComponent) {
        println("Graphic was added!")
    }
    
    func graphicWasRemovedFromScene(graphic: GraphicsComponent) {
        println("Graphic was removed!")
    }
}