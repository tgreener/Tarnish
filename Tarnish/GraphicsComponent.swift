//
//  GraphicsComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol GraphicsComponentListener: class {
    func graphicWasRemovedFromScene() -> Void
    func graphicWasAddedToScene() -> Void
    func graphicMovedToPosition(position: MapPosition) -> Void
}

protocol GraphicsComponent : PositionComponentListener {
    func addListener(listener: GraphicsComponentListener) -> Void
    
    func addTo(node: SKNode) -> Void
    func addChildGraphic(graphic: GraphicNode) -> Void
    
    func insertTo(node: SKNode, atIndex: Int) -> Void
    func insertChildGraphic(graphic: GraphicNode, atIndex: Int) -> Void
    
    func removeFromParent() -> Void
    func getNode() -> SKNode
}

class GraphicNode : SKSpriteNode, GraphicsComponent {
    var listeners : [GraphicsComponentListener] = [GraphicsComponentListener]()
    let notifier  : Notifier<GraphicsComponentListener> = Notifier<GraphicsComponentListener>()
    
    func addListener(listener: GraphicsComponentListener) {
        notifier.addListener(listener)
    }
    
    func notifyAddedToScene() {
        notifier.notify({ listener in listener.graphicWasAddedToScene() })
    }
    
    func notifyRemovedFromScene() {
        notifier.notify({ listener in listener.graphicWasRemovedFromScene() })
    }
    
    func notifyMovedTo(position: MapPosition) {
        notifier.notify({ listener in listener.graphicMovedToPosition(position)})
    }
    
    func addTo(node: SKNode) {
        assert(self.parent == nil, "Tried to add GraphicsComponent when already in scene")
        node.addChild(self)
        notifyAddedToScene()
    }
    
    func insertTo(node: SKNode, atIndex: Int) {
        assert(self.parent == nil, "Tried to add GraphicsComponent when already in scene")
        node.insertChild(self, atIndex: atIndex)
        notifyAddedToScene()
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        notifyRemovedFromScene()
    }
    
    func addChildGraphic(graphic: GraphicNode) {
        assert(graphic.parent == nil, "Tried to add GraphicsComponent when already in scene")
        self.addChild(graphic)
        graphic.notifyAddedToScene()
    }
    
    func insertChildGraphic(graphic: GraphicNode, atIndex: Int) {
        assert(graphic.parent == nil, "Tried to add GraphicsComponent when already in scene")
        self.insertChild(graphic, atIndex: atIndex)
        graphic.notifyAddedToScene()

    }
    
    func positionMovedTo(position: MapPosition, from: MapPosition, map: GameMap) {
        self.runAction(SKAction.moveTo(map.convertToMapNodeSpace(position), duration: 0.6), completion: {
            self.notifyMovedTo(position)
        })
    }
    
    func positionSetTo(position: MapPosition, from: MapPosition, map: GameMap) {
        self.position = map.convertToMapNodeSpace(position)
    }
    
    func getNode() -> SKNode {
        return self
    }
}
