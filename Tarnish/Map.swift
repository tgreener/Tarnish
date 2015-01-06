//
//  Map.swift
//  Tarnish
//
//  Created by Todd Greener on 1/5/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation

protocol GameMapInterface {
    func mapSpaceAt(x : Int, y : Int, z : Int) -> MapSpace
}

class GameMap : GameMapInterface {
    var container : [[[MapSpace]]]
    
    init(size : Int) {
        container = [[[MapSpace]]](count: size, repeatedValue:
                     [[MapSpace]] (count: size, repeatedValue:
                      [MapSpace]  (count: size, repeatedValue:
                       MapSpace   ())))
    }
    
    func mapSpaceAt(x: Int, y: Int, z : Int) -> MapSpace {
        return self.container[x][y][z];
    }
}
