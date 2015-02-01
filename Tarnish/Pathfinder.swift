//
//  Pathfinder.swift
//  Tarnish
//
//  Created by Todd Greener on 1/18/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol PathfinderDelegate: class {
    func pathfinderReachedGoal() -> Void
}

protocol Pathfinder: class {
    func update(inout claims : [MapPosition: [PathStepper]]) -> Void
    func goTo(goal: MapPosition) -> Void
}


class PathfinderImpl: Pathfinder, PathStepperDelegate {
    unowned let entityPosition : PositionComponent
    unowned let map : GameMap
    unowned let delegate : PathfinderDelegate
    
    var goal : MapPosition!
    var pathStepper : PathStepper!
    var isCalculatingPath = false
    
    init(entityPosition: PositionComponent, delegate: PathfinderDelegate, map: GameMap) {
        self.entityPosition = entityPosition
        self.map = map
        self.delegate = delegate
    }
    
    func update(inout claims : [MapPosition: [PathStepper]]) {
        if isCalculatingPath || self.entityPosition.isMoving { return }
        
        if let stepper = self.pathStepper {
            stepper.update(&claims)
        }
    }
    
    func goTo(goal: MapPosition) {
        self.goal = goal
        isCalculatingPath = true
        
        AIOperationQueue.addOperationWithBlock {
            let astar : AStar = AStarImpl(start: self.entityPosition.mapPosition, end: self.goal, map: self.map)
            let path : [MapPosition]? = astar.calculatePartialPath(iterations: 10)
            
            if let newPath = path {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.pathStepper = PathStepper(path: newPath, delegate: self, positionComponent: self.entityPosition)
                    self.isCalculatingPath = false
                }
            }
            else {
                self.goTo(self.goal)
            }
        }
    }
    
    func stepperStopped() {
        if self.entityPosition.mapPosition != self.goal! {
            goTo(self.goal)
        }
        else {
            self.delegate.pathfinderReachedGoal()
        }
    }
}
