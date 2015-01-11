//
//  PositionComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

struct MapPosition : Equatable {
    let x : UInt
    let y : UInt
    let z : UInt
    
    init(x: UInt, y: UInt, z: UInt) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(position: MapPosition) {
        self.x = position.x
        self.y = position.y
        self.z = position.z
    }
}


func ==(lhs: MapPosition, rhs: MapPosition) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

protocol PositionComponent : class {
    func addListener(listener: PositionComponentListener) -> Void
    var mapPosition : MapPosition { get set }
    var entity      : Entity!     { get set }
}

class PositionComponentImpl : PositionComponent {
    var mapPosition : MapPosition = MapPosition(x: 0, y: 0, z: 0){
        didSet(previousPosition) {
            if !assumeNewPosition(self.mapPosition, previousPosition: previousPosition) {
                self.mapPosition = previousPosition
            }
            else {
                notifyListenersPositionChanged()
            }
        }
    }
    
    var listeners: [PositionComponentListener] = [PositionComponentListener]()
    weak var entity : Entity!
    unowned let map : GameMapImpl
    
    init(map: GameMapImpl) {
        self.map = map
    }
    
    func notifyListenersPositionChanged() {
        for listener in listeners {
            let position = MapPosition(position: self.mapPosition)
            listener.mapPositionChanged(position, map: self.map)
        }
    }
    
    func assumeNewPosition(newPosition: MapPosition, previousPosition: MapPosition) -> Bool {
        let destinationSpace = map.mapSpaceAt(newPosition.x, y: newPosition.y, z: newPosition.z)
        let currentSpace = map.mapSpaceAt(previousPosition.x, y: previousPosition.y, z: previousPosition.z)
        
        if !destinationSpace.containsEntity() {
            if currentSpace.getEntity() === self.entity {
                currentSpace.removeEntity()
            }
            destinationSpace.insertEntity(self.entity)
            
            return true
        }
        else { return false }
    }
    
    func addListener(listener: PositionComponentListener) -> Void {
        self.listeners.append(listener)
    }

}

protocol PositionComponentListener {
    func mapPositionChanged(position: MapPosition, map: GameMap) -> Void
}
