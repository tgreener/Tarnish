//
//  GameScene.swift
//  ARGMon Proto
//
//  Created by Todd Greener on 12/13/14.
//  Copyright (c) 2014 Todd Greener. All rights reserved.
//

import SpriteKit

class TitleScene: BaseScene {
    
    var titleNode : SKLabelNode!
    var map : GameMap!
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let space = self.map.mapSpaceAt(0, y: 0, z:0)
        if space.containsEntity() {
            space.removeEntity()
            
            if !space.containsEntity() {
                titleNode.text = "Removed!"
            }
        }
        else {
            let comp : ExampleComponent = ExampleComponent()
            let entity : Entity = Entity(exampleComponent: comp)
            space.insertEntity(entity)
            
            if space.containsEntity() {
                titleNode.text = "Got the Entity!"
            }
        }
    }

    override func createSceneContents() -> Void
    {
        super.createSceneContents()
        self.backgroundColor = SKColor.grayColor()
        self.scaleMode = .AspectFit
        self.size = self.view!.frame.size
        self.createHelloNode()
        
        map = GameMap(size: 100)
    }
    
    func createHelloNode() -> Void
    {
        self.titleNode = SKLabelNode(fontNamed:"Chalkduster")
        let touchToStartNode : SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
        
        titleNode.text = "TARNISH"
        titleNode.fontSize = 65
        
        touchToStartNode.text = "Touch to Start"
        touchToStartNode.fontSize = 35
        
        titleNode.addChild(touchToStartNode)
        
        let size = self.size
        let pos = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        titleNode.position = pos
        touchToStartNode.position = CGPointMake(0, -50)
        
        self.addChild(self.titleNode)
    }
}