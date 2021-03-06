//
//  AIComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/15/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol AIComponent  {
    func update(dt: NSTimeInterval, inout claims: [MapPosition : [PathStepper]]) -> Void
    func addListener(listener: AIComponentListener) -> Void
}

class AIComponentImpl : AIComponent, PositionComponentListener, PathfinderDelegate {
    let notifier : Notifier<AIComponentListener> = Notifier<AIComponentListener>()
    let needs : NeedManager = NeedManager()
    
    let map : GameMap
    var pathFinder : Pathfinder!
    
    var goal : MapPosition?  // In the future, I'll need to make a system with more descriptive goal classes
    weak var positionComponent : PositionComponent!
    
    init(map: GameMap, positionComponent: PositionComponent) {
        self.positionComponent = positionComponent
        self.map = map
        self.pathFinder = PathfinderImpl(entityPosition: self.positionComponent, delegate: self, map: self.map)
    }
    
    func generateGoal() -> Void {
        while goal == nil || !map.mapSpaceAt(goal!).isPathable() {
            let goalX = random(0, maxVal: map.size)
            let goalY = random(0, maxVal: map.size)
            let goalZ : UInt = 0
            
            goal = MapPosition(x: goalX, y: goalY, z: goalZ)
            print("Created goal: \(goal)")
        }
    }
    
    func update(dt: NSTimeInterval, inout claims: [MapPosition : [PathStepper]]) {
        needs.update(dt)
        
        if goal == nil {
            generateGoal()
            pathFinder.goTo(self.goal!)
        }
        
        pathFinder.update(&claims)
    }
    
    func positionMovedTo(position: MapPosition, from:MapPosition, map: GameMap) {
        
    }
    
    func positionSetTo(position: MapPosition, from: MapPosition, map: GameMap) {
        
    }
    
    func pathfinderReachedGoal() -> Void {
        self.goal = nil
        self.notifier.notify({listener in listener.reachedGoal()})
    }
    
    func addListener(listener: AIComponentListener) {
        notifier.addListener(listener)
    }

}

protocol AIComponentListener: class {
    func reachedGoal() -> Void
}
