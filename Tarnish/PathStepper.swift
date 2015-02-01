//
//  PathStepper.swift
//  Tarnish
//
//  Created by Todd Greener on 1/18/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol PathStepperDelegate: class {
    func stepperStopped() -> Void
}

class PathStepper {
    
    let path : [MapPosition]
    var itr  : IndexingGenerator<[MapPosition]>
    var nextStep : MapPosition?
    var inPosition = false
    
    unowned let position   : PositionComponent
    unowned let delegate : PathStepperDelegate
    
    init(path: [MapPosition], delegate: PathStepperDelegate, positionComponent: PositionComponent) {
        self.path = path
        self.itr = self.path.generate()
        self.nextStep = self.itr.next()
        self.position = positionComponent
        self.delegate = delegate
        
        while self.nextStep == self.position.mapPosition {
            self.nextStep = self.itr.next()
        }
    }
    
    func update(inout claims: [MapPosition: [PathStepper]]) {
        if let step : MapPosition = self.nextStep {
            if self.position.mapPosition != self.nextStep && self.position.mapPosition.distanceSquaredTo(step) <= 1 {
                if var claimingEntities = claims[step] {
                    claimingEntities.append(self)
                }
                else {
                    var claimingEntities : [PathStepper] = [PathStepper]()
                    claimingEntities.append(self)
                    claims[step] = claimingEntities
                }
            }
            else {
                self.stop()
            }
        }
    }
    
    func stop() {
        self.nextStep = nil
        delegate.stepperStopped()
    }
    
    func step() {
        assert(self.nextStep != nil, "Asked an entity to take a step that does not have a next step")
        if let step = self.nextStep {
            self.position.moveTo(step)
            self.nextStep = self.itr.next()
            if self.nextStep == nil { self.delegate.stepperStopped() }
        }
    }
}
