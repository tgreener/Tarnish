//
//  AIComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/15/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol AIComponent  {
    func update(dt: NSTimeInterval) -> Void
    func addListener(listener: AIComponentListener) -> Void
}

class AIComponentImpl : AIComponent, PositionComponentListener, GraphicsComponentListener {
    let notifier : Notifier<AIComponentListener> = Notifier<AIComponentListener>()
    let map : GameMap
    var isReady = false
    var isMoving = false
    var currentPosition : MapPosition?
    var currentPath : [MapPosition]?
    var pathItr : IndexingGenerator<Array<MapPosition>>!
    var currentStep : MapPosition?
    
    var goal : MapPosition?  // In the future, I'll need to make a system with more descriptive goal classes
    var positionComponent : PositionComponent!
    
    init(map: GameMap, positionComponent: PositionComponent) {
        self.positionComponent = positionComponent
        self.map = map
    }
    
    deinit {
        positionComponent = nil
    }
    
    func generateGoal() -> Void {
        while goal == nil || !map.mapSpaceAt(goal!).isPathable() {
            let goalX = random(0, map.size)
            let goalY = random(0, map.size)
            let goalZ : UInt = 0
            
            goal = MapPosition(x: goalX, y: goalY, z: goalZ)
            println("Created goal: \(goal)")
        }
    }
    
    func update(dt: NSTimeInterval) {
        if isReady && !isMoving {
            if goal == nil {
                generateGoal()
                let astar : AStar = AStarImpl(start: currentPosition!, end: goal!, map: map)
                astar.calculatePath({path in
                    self.currentPath = path
                    self.pathItr = self.currentPath?.generate()
                    while let step = self.pathItr.next() {
                        if step != self.currentPosition! {
                            self.currentStep = step
                            break
                        }
                    }
                })
            }
            else if self.pathItr != nil {
                if let step = self.currentStep {
                    if map.mapSpaceAt(step).isPathable() && currentPosition!.distanceSquaredTo(step) <= 1 && step != currentPosition {
                        positionComponent.moveTo(step)
                        self.currentStep = self.pathItr.next()
                    }
                }
            }
        }
    }
    
    func positionMovedTo(position: MapPosition, from:MapPosition, map: GameMap) {
        currentPosition = position
        isMoving = true
    }
    
    func positionSetTo(position: MapPosition, from: MapPosition, map: GameMap) {
        currentPosition = position
    }
    
    func graphicMovedToPosition(graphic: GraphicsComponent, position: MapPosition) {
        if isMoving && currentPosition == position { isMoving = false }
        if position == goal {
            goal = nil
            currentPath = nil
            pathItr = nil
            
            notifier.notify({ listener in listener.reachedGoal() })
        }
    }
    
    func graphicWasAddedToScene(graphic: GraphicsComponent) {
        isReady = true
    }
    
    func graphicWasRemovedFromScene(graphic: GraphicsComponent) {
        isReady = false
    }
    
    func addListener(listener: AIComponentListener) {
        notifier.listeners.append(listener)
    }

}

protocol AIComponentListener {
    func reachedGoal() -> Void
}
