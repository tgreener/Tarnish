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

class AStarImpl : AStar {
    let map : GameMap
    
    var closedSet : [MapPosition] = [MapPosition]()
    var openSet   : PriorityQueue<Double, MapPosition> = PriorityQueue()
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
        openSet.push(estimatedDistance[start]!, item: start)
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
                if current == self.goal {
                    self.lastCalculatedPosition = current
                    
                    return self.createPath()
                }
                self.closedSet.append(current)
                
                for position : MapPosition in self.map.getPathableNeighbors(current) {
                    if contains(self.closedSet, position) { continue }
                    
                    let possibleDistance : Double = self.knownDistance[current]! + 1 // Travel between all terrain squares is currently just 1
                    if !self.openSet.contains(position) || self.knownDistance[position] > possibleDistance {
                        self.positionBefore[position] = current
                        self.knownDistance[position]  = possibleDistance
                        self.estimatedDistance[position] = self.knownDistance[position]! + self.heuristic(position, goal: self.goal)
                        if !self.openSet.contains(position) {
                            self.openSet.push(self.estimatedDistance[position]!, item: position)
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
                if current == self.goal || count >= i {
                    self.lastCalculatedPosition = current
                    
                    return self.createPath()
                }
                self.closedSet.append(current)
                
                for position : MapPosition in self.map.getPathableNeighbors(current) {
                    if contains(self.closedSet, position) { continue }
                    
                    let possibleDistance : Double = self.knownDistance[current]! + 1 // Travel between all terrain squares is currently just 1
                    if !self.openSet.contains(position) || self.knownDistance[position] > possibleDistance {
                        self.positionBefore[position] = current
                        self.knownDistance[position]  = possibleDistance
                        self.estimatedDistance[position] = self.knownDistance[position]! + self.heuristic(position, goal: self.goal)
                        if !self.openSet.contains(position) {
                            self.openSet.push(self.estimatedDistance[position]!, item: position)
                        }
                    }
                }
            }
            
            count++
        }
        return nil
    }
    
}
