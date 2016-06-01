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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let playScene : PlayScene = PlayScene()
        let view : SKView = self.view!
        view.presentScene(playScene)
    }

    override func createSceneContents() -> Void
    {
        super.createSceneContents()
        self.createHelloNode()
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
