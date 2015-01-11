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
    let idleAnimationAction : SKAction
    let runAnimationAction  : SKAction
    var currentAction : SKAction = SKAction() {
        didSet {
            self.runAction(currentAction)
        }
    }
    
    init(beardlingTextures: [BeardlingTextureType: SKTexture]) {
        idleTextures = [beardlingTextures[BeardlingTextureType.Idle1]!, beardlingTextures[BeardlingTextureType.Idle2]!]
        runTextures  = [beardlingTextures[BeardlingTextureType.Run1]!,  beardlingTextures[BeardlingTextureType.Run2]!]
        
        idleAnimationAction = SKAction.repeatActionForever(SKAction.animateWithTextures(idleTextures, timePerFrame: 0.5))
        runAnimationAction  = SKAction.repeatActionForever(SKAction.animateWithTextures(runTextures, timePerFrame: 0.2))
        currentAction = idleAnimationAction
        
        let defaultTex = beardlingTextures[BeardlingTextureType.Idle1]
        
        super.init(texture: defaultTex, color: SKColor.redColor(), size: defaultTex!.size())
        self.runAction(idleAnimationAction)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.userInteractionEnabled = true
    }
    
    override func notifyMovedTo(position: MapPosition) {
        currentAction = self.idleAnimationAction
        super.notifyMovedTo(position)
    }
    
    override func mapPositionChanged(position: MapPosition, map: GameMap) {
        if self.position != map.convertToMapNodeSpace(position) {
            super.mapPositionChanged(position, map: map)
            currentAction = self.runAnimationAction
        }
    }
}
