//
//  BeardlingGraphicComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/10/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class BeardlingGraphicComponent : GraphicNode, AIComponentListener {
    let idleTextures : [SKTexture]
    let runTextures  : [SKTexture]
    let idleAnimationAction : SKAction!
    let runAnimationAction  : SKAction!
    var currentAction : SKAction = SKAction() {
        didSet {
            if oldValue !== currentAction {
                self.removeActionForKey("BEARDLING_ANIMATION")
                self.runAction(currentAction, withKey: "BEARDLING_ANIMATION")
            }
        }
    }
    
    init(beardlingTextures: [BeardlingTextureType: SKTexture]) {
        idleTextures = [beardlingTextures[BeardlingTextureType.Idle1]!, beardlingTextures[BeardlingTextureType.Idle2]!]
        runTextures  = [beardlingTextures[BeardlingTextureType.Run1]!,  beardlingTextures[BeardlingTextureType.Run2]!]
        
        let defaultTex = beardlingTextures[BeardlingTextureType.Idle1]
        
        super.init(texture: defaultTex, color: SKColor.whiteColor(), size: defaultTex!.size())
        idleAnimationAction = createIdleAnimationAction()
        runAnimationAction  = createRunAnimationAction()
        currentAction = idleAnimationAction
        
        self.runAction(idleAnimationAction, withKey: "BEARDLING_ANIMATION")
        self.anchorPoint = CGPointZero
        self.userInteractionEnabled = true
        self.zPosition = 2.0
    }
    
    func createIdleAnimationAction() -> SKAction {
        return SKAction.repeatActionForever(SKAction.animateWithTextures(idleTextures, timePerFrame: 1.00))
    }
    
    func createRunAnimationAction() -> SKAction {
        return SKAction.repeatActionForever(SKAction.animateWithTextures(runTextures, timePerFrame: 0.2))
    }
    
    override func positionMovedTo(position: MapPosition, from: MapPosition, map: GameMap) {
        if self.position != map.convertToMapNodeSpace(position) {
            
            if Int(from.x) - Int(position.x) > 0 {
                if self.xScale > 0 {
                    self.anchorPoint = CGPoint(x: 1, y: 0)
                    self.xScale = self.xScale * -1
                }
            }
            else if self.xScale < 0 && Int(from.x) < Int(position.x) {
                self.xScale = self.xScale * -1
                self.anchorPoint = CGPointZero
            }
            
            currentAction = self.runAnimationAction
            super.positionMovedTo(position, from: from, map: map)
        }
    }
    
    func reachedGoal() {
        currentAction = self.idleAnimationAction
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
