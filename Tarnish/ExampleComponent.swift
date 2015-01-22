//
//  ExampleComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

class ExampleComponent : GraphicsComponentListener{
    
    func graphicWasAddedToScene() {
//        println("Graphic was added!")
    }
    
    func graphicWasRemovedFromScene() {
        println("Graphic was removed!")
    }
    
    func graphicMovedToPosition(position: MapPosition) -> Void {
//        println("Graphic moved to map position!")
    }
}