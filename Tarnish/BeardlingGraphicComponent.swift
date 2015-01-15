//
//  BeardlingGraphicComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class BeardlingGraphicComponent : GraphicNode {
    let idleTextures : [SKTexture]
    let runTextures  : [SKTexture]
    let idleAnimationAction : SKAction!
    let runAnimationAction  : SKAction!
    var currentAction : SKAction = SKAction() {
        didSet {
            self.removeActionForKey("BEARDLING_ANIMATION")
            self.runAction(currentAction, withKey: "BEARDLING_ANIMATION")
        }
    }
    
    init(beardlingTextures: [BeardlingTextureType: SKTexture]) {
        idleTextures = [beardlingTextures[BeardlingTextureType.Idle1]!, beardlingTextures[BeardlingTextureType.Idle2]!]
        runTextures  = [beardlingTextures[BeardlingTextureType.Run1]!,  beardlingTextures[BeardlingTextureType.Run2]!]
        
        let defaultTex = beardlingTextures[BeardlingTextureType.Idle1]
        
        super.init(texture: defaultTex, color: SKColor.redColor(), size: defaultTex!.size())
        idleAnimationAction = createIdleAnimationAction()
        runAnimationAction  = createRunAnimationAction()
        currentAction = idleAnimationAction
        
        self.runAction(idleAnimationAction)
        self.anchorPoint = CGPointZero
        self.userInteractionEnabled = true
    }
    
    func createIdleAnimationAction() -> SKAction {
        return SKAction.repeatActionForever(SKAction.animateWithTextures(idleTextures, timePerFrame: 1.00))
    }
    
    func createRunAnimationAction() -> SKAction {
        return SKAction.repeatActionForever(SKAction.animateWithTextures(runTextures, timePerFrame: 0.2))
    }
    
    override func notifyMovedTo(position: MapPosition) {
        currentAction = self.idleAnimationAction
        super.notifyMovedTo(position)
    }
    
    override func positionMovedTo(position: MapPosition, map: GameMap) {
        if self.position != map.convertToMapNodeSpace(position) {
            super.positionMovedTo(position, map: map)
            currentAction = self.runAnimationAction
        }
    }
}

class BraidlingGraphicComponent : BeardlingGraphicComponent {
    override func createIdleAnimationAction() -> SKAction {
        return SKAction.runBlock({
            let randomNumber : NSTimeInterval = NSTimeInterval(Float(random(5, 10)) * 0.5)
            let sequence : SKAction = SKAction.sequence([
                SKAction.animateWithTextures(self.idleTextures, timePerFrame: randomNumber),
                SKAction.runBlock({self.runAction(self.createIdleAnimationAction())})
            ])
            
            self.runAction(sequence, withKey: "BEARDLING_ANIMATION")
        })
    }
}