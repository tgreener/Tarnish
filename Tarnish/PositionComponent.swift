//
//  PositionComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol BoardPositionListener {
    func boardPositionChanged(position: BoardPosition) -> Void
}

class BoardPosition {
    var x : UInt = 0
    var y : UInt = 0
    var z : UInt = 0
    
    init(x: UInt, y: UInt, z: UInt) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    convenience init(position: BoardPosition) {
        self.init(x: position.x, y: position.y, z: position.z)
    }
}

protocol PositionComponent {
    func addListener(listener: BoardPositionListener) -> Void
    
    func setPosition(position: BoardPosition) -> Void
    func setPosition(x: UInt, y: UInt, z: UInt) -> Void
}

class PositionComponentImpl : PositionComponent {
    var position : BoardPosition = BoardPosition(x: 0, y: 0, z: 0)
    var listeners: [BoardPositionListener] = [BoardPositionListener]()
    
    init(position: BoardPosition) {
        self.position = position
    }
    
    func addListener(listener: BoardPositionListener) -> Void {
        self.listeners.append(listener)
    }
    
    func notifyPositionChanged() {
        for listener in listeners {
            let position = BoardPosition(position: self.position)
            listener.boardPositionChanged(position)
        }
    }
    
    func setPosition(position: BoardPosition) -> Void {
        self.position = position
    }
    
    func setPosition(x: UInt, y: UInt, z: UInt) -> Void {
        self.position.x = x
        self.position.y = y
        self.position.z = z
    }
}
