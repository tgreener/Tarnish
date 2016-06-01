//
//  AStar.swift
//  Tarnish
//
//  Created by Todd Greener on 1/14/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol AStar {
    func calculatePath() -> [MapPosition]?
    func calculatePartialPath(iterations i: UInt) -> [MapPosition]?
}

struct MapPositionPriorityNode :Equatable {
    let distance : Double
    let position : MapPosition
}

func ==(lhs: MapPositionPriorityNode, rhs: MapPositionPriorityNode) -> Bool {
    return lhs.position == rhs.position
}

func ==(lhs: MapPosition, rhs: MapPositionPriorityNode) -> Bool {
    return lhs == rhs.position
}

func ==(lhs: MapPositionPriorityNode, rhs: MapPosition) -> Bool {
    return lhs.position == rhs
}

class AStarImpl : AStar {
    let map : GameMap
    
    var closedSet : [MapPosition] = [MapPosition]()
    var openSet   : PriorityQueue<MapPositionPriorityNode> = PriorityQueue({ $0.distance < $1.distance })
    var positionBefore    : [MapPosition: MapPosition] = [MapPosition: MapPosition]()
    var knownDistance     : [MapPosition: Double] = [MapPosition: Double]()
    var estimatedDistance : [MapPosition: Double] = [MapPosition: Double]()
    
    var goal : MapPosition
    var lastCalculatedPosition : MapPosition
    
    init(start: MapPosition, end: MapPosition, map: GameMap) {
        self.map = map
        
        self.goal = end
        self.lastCalculatedPosition = start
        
        knownDistance[start] = 0
        estimatedDistance[start] = knownDistance[start]! + heuristic(start, goal: end)
        openSet.push(MapPositionPriorityNode(distance: estimatedDistance[start]!, position: start))
    }
    
    func heuristic(current: MapPosition, goal: MapPosition) -> Double {
        return current.distanceSquaredTo(goal)
    }
    
    func createPath() -> [MapPosition] {
        var path = [MapPosition]()
        var current : MapPosition? = lastCalculatedPosition
        path.append(lastCalculatedPosition)
        
        while let position = positionBefore[current!] {
            current = position
            if current == nil { break }
            
            path.insert(current!, atIndex: 0)
        }
        
        return path
    }
    
    func calculatePath() -> [MapPosition]? {
        while self.openSet.count > 0 {
            if let current = self.openSet.next() {
                if current.position == self.goal {
                    self.lastCalculatedPosition = current.position
                    
                    return self.createPath()
                }
                self.closedSet.append(current.position)
                
                for position : MapPosition in self.map.getPathableNeighbors(current.position) {
                    if self.closedSet.contains(position) { continue }
                    
                    let possibleDistance : Double = self.knownDistance[current.position]! + 1 // Travel between all terrain squares is currently just 1
                    if !self.openSet.contains(MapPositionPriorityNode(distance: 0.0, position: position)) || self.knownDistance[position] > possibleDistance {
                        self.positionBefore[position] = current.position
                        self.knownDistance[position]  = possibleDistance
                        self.estimatedDistance[position] = self.knownDistance[position]! + self.heuristic(position, goal: self.goal)
                        if !self.openSet.contains(MapPositionPriorityNode(distance: 0.0, position: position)) {
                            self.openSet.push(MapPositionPriorityNode(distance: estimatedDistance[position]!, position: position))
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    func calculatePartialPath(iterations i: UInt) -> [MapPosition]? {
        var count : UInt = 0
        
        while self.openSet.count > 0 {
            if let current = self.openSet.next() {
                if current.position == self.goal || count >= i {
                    self.lastCalculatedPosition = current.position
                    
                    return self.createPath()
                }
                self.closedSet.append(current.position)
                
                for position : MapPosition in self.map.getPathableNeighbors(current.position) {
                    if self.closedSet.contains(position) { continue }
                    
                    let possibleDistance : Double = self.knownDistance[current.position]! + 1 // Travel between all terrain squares is currently just 1
                    if !self.openSet.contains(MapPositionPriorityNode(distance: 0.0, position: position)) || self.knownDistance[position] > possibleDistance {
                        self.positionBefore[position] = current.position
                        self.knownDistance[position]  = possibleDistance
                        self.estimatedDistance[position] = self.knownDistance[position]! + self.heuristic(position, goal: self.goal)
                        if !self.openSet.contains(MapPositionPriorityNode(distance: 0.0, position: position)) {
                            self.openSet.push(MapPositionPriorityNode(distance: estimatedDistance[position]!, position: position))
                        }
                    }
                }
            }
            
            count += 1
        }
        return nil
    }
    
}
