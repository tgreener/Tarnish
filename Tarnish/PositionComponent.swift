//
//  PositionComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol PositionComponent : class {
    func addListener(listener: PositionComponentListener) -> Void
    
    func moveTo(position: MapPosition) -> Void
    func setTo(position : MapPosition) -> Void
    
    var entity      : Entity!     { get set }
    var mapPosition : MapPosition { get }
}

class PositionComponentImpl : PositionComponent {
    var mapPosition : MapPosition = MapPosition(x: 0, y: 0, z: 0)
    
    var listeners: [PositionComponentListener] = [PositionComponentListener]()
    weak var entity : Entity!
    unowned let map : GameMapImpl
    
    init(map: GameMapImpl) {
        self.map = map
    }
    
    func notify(closure: (PositionComponentListener) -> Void) {
        for listener in listeners {
            closure(listener)
        }
    }
    
    func assumeNewPosition(newPosition: MapPosition, previousPosition: MapPosition) -> Bool {
        let destinationSpace = map.mapSpaceAt(newPosition.x, y: newPosition.y, z: newPosition.z)
        let currentSpace = map.mapSpaceAt(previousPosition.x, y: previousPosition.y, z: previousPosition.z)
        
        if !destinationSpace.containsEntity() {
            if currentSpace.getEntity() === self.entity {
                map.removeEntity(atPosition: previousPosition)
            }
            map.insert(entity: self.entity, atPosition: newPosition)
            self.mapPosition = newPosition
            
            return true
        }
        else { return false }
    }
    
    func addListener(listener: PositionComponentListener) -> Void {
        self.listeners.append(listener)
    }
    
    func moveTo(position: MapPosition) -> Void {
        let previousPosition = self.mapPosition
        if assumeNewPosition(position, previousPosition: previousPosition) {
            notify({listener in listener.positionMovedTo(self.mapPosition, from: previousPosition, map: self.map) })
        }
    }

    func setTo(position: MapPosition) {
        let previousPosition = self.mapPosition
        if assumeNewPosition(position, previousPosition: previousPosition) {
            notify({listener in listener.positionSetTo(self.mapPosition, from: previousPosition, map: self.map) })
        }
    }
}

protocol PositionComponentListener {
    func positionMovedTo(position: MapPosition, from: MapPosition, map: GameMap) -> Void
    func positionSetTo(position: MapPosition, from: MapPosition, map: GameMap) -> Void
}
