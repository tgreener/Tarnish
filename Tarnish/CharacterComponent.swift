//
//  CharacterComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/14/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol CharacterComponent {
    func isCharacter() -> Bool
}

class CharacterComponentImpl : CharacterComponent {
    func isCharacter() -> Bool {
        return true
    }
}

