//
//  GraphicsComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol GraphicsComponentListener {
    func graphicWasRemovedFromScene(graphic: GraphicsComponent) -> Void
    func graphicWasAddedToScene(graphic: GraphicsComponent) -> Void
    func graphicMovedToPosition(graphic: GraphicsComponent, position: MapPosition) -> Void
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
    
    func addListener(listener: GraphicsComponentListener) {
        listeners.append(listener)
    }
    
    func notify(closure: (GraphicsComponentListener) -> Void) {
        for listener in listeners {
            closure(listener)
        }
    }
    
    func notifyAddedToScene() {
        notify({ listener in listener.graphicWasAddedToScene(self) })
    }
    
    func notifyRemovedFromScene() {
        notify({ listener in listener.graphicWasRemovedFromScene(self) })
    }
    
    func notifyMovedTo(position: MapPosition) {
        notify({ listener in listener.graphicMovedToPosition(self, position: position)})
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
    
    func mapPositionChanged(position: MapPosition, map: GameMap) {
        self.runAction(SKAction.moveTo(map.convertToMapNodeSpace(position), duration: 0.5), {
            self.notifyMovedTo(position)
        })
    }
    
    func getNode() -> SKNode {
        return self
    }
}
