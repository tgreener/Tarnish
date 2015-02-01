//
//  PositionComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol PositionComponent : class, GraphicsComponentListener {
    func addListener(listener: PositionComponentListener) -> Void
    
    func moveTo(position: MapPosition) -> Bool
    func setTo(position : MapPosition) -> Bool
    
    var entity      : Entity!     { get set }
    var mapPosition : MapPosition { get }
    var isMoving    : Bool        { get }
}

class PositionComponentImpl : PositionComponent {
    var mapPosition : MapPosition = MapPosition(x: 0, y: 0, z: 0)
    var isMoving : Bool = false
    
    let notifier : Notifier<PositionComponentListener> = Notifier<PositionComponentListener>()
    weak var entity : Entity!
    unowned let map : GameMap
    
    init(map: GameMap) {
        self.map = map
    }
    
    func assumeNewPosition(newPosition: MapPosition, previousPosition: MapPosition) -> Bool {
        let destinationSpace = map.mapSpaceAt(newPosition.x, y: newPosition.y, z: newPosition.z)
        let currentSpace = map.mapSpaceAt(previousPosition.x, y: previousPosition.y, z: previousPosition.z)
        
        if !self.entity.physics.blocksPathing || destinationSpace.isPathable() && !isMoving {
            if currentSpace.getEntity(self.entity) != nil {
                map.removeEntity(self.entity, atPosition: previousPosition)
            }
            map.insert(entity: self.entity, atPosition: newPosition)
            self.mapPosition = newPosition
            
            return true
        }
        else { return false }
    }
    
    func addListener(listener: PositionComponentListener) -> Void {
        notifier.addListener(listener)
    }
    
    func moveTo(position: MapPosition) -> Bool {
        let previousPosition = self.mapPosition
        if assumeNewPosition(position, previousPosition: previousPosition) {
            notifier.notify({listener in listener.positionMovedTo(self.mapPosition, from: previousPosition, map: self.map) })
            isMoving = true
            return true
        }
        return false
    }

    func setTo(position: MapPosition) -> Bool {
        let previousPosition = self.mapPosition
        if assumeNewPosition(position, previousPosition: previousPosition) {
            notifier.notify({listener in listener.positionSetTo(self.mapPosition, from: previousPosition, map: self.map) })
            return true
        }
        return false
    }
    
    func graphicMovedToPosition(position: MapPosition) {
        isMoving = false
    }
    
    func graphicWasAddedToScene() {}
    func graphicWasRemovedFromScene() {}
}

protocol PositionComponentListener: class {
    func positionMovedTo(position: MapPosition, from: MapPosition, map: GameMap) -> Void
    func positionSetTo(position: MapPosition, from: MapPosition, map: GameMap) -> Void
}
