//
//  BaseScene.swift
//  ARGMon Proto
//
//  Created by Todd Greener on 12/20/14.
//  Copyright (c) 2014 Todd Greener. All rights reserved.
//

import SpriteKit

class BaseScene : SKScene {
    var contentCreated : Bool = false
    
    override func didMoveToView(view: SKView) -> Void
    {
        if !self.contentCreated
        {
            self.createSceneContents()
        }
    }

    func createSceneContents() {
        self.contentCreated = true
    }
    
}
