//
//  InanimateComponent.swift
//  Tarnish
//
//  Created by Todd Greener on 1/14/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

protocol PhysicalComponent {
    var blocksPathing : Bool { get }
}

class PhysicalComponentImpl : PhysicalComponent {
    let blocksPathing : Bool
    
    init(blocksPathing : Bool) {
        self.blocksPathing = blocksPathing
    }
}

