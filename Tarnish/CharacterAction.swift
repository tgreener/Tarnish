//
//  Action.swift
//  Tarnish
//
//  Created by Todd Greener on 3/30/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import Foundation


protocol CharacterAction {
    func isComplete() -> Bool
    func update(delta: NSTimeInterval) -> Void
}