//
//  GraphicsFactory.swift
//  Tarnish
//
//  Created by Todd Greener on 1/6/15.
//  Copyright (c) 2015 Todd Greener. All rights reserved.
//

import SpriteKit

class GraphicsFactory {
    // Load methods
    func loadAllTextures() {
        loadDwarfAtlas()
    }
    
    func loadDwarfAtlas() {
        self.dwarfAtlas = SKTexture(imageNamed: "dwarves.png")
        self.regularDwarfTexture = SKTexture(rect: self.dwarfAtlasPositions[DwarfType.Regular]!, inTexture: self.dwarfAtlas)
    }
    
    // Factory methods
    func createRegularDwarfGraphic() -> GraphicNode {
        let result = GraphicNode(texture: self.regularDwarfTexture)
        result.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        return result
    }
    
    
    var dwarfAtlas : SKTexture!
    var regularDwarfTexture : SKTexture!
    
    enum DwarfType {
        case Regular
    }
    let dwarfWidth : CGFloat = 16.0 / 192.0
    let dwarfHeight: CGFloat = 16.0 / 352.0
    let dwarfAtlasPositions : [DwarfType: CGRect]
    
    init() {
        dwarfAtlas = nil
        regularDwarfTexture = nil
        
        // Positions in atlas for all dwarf sprites
        dwarfAtlasPositions = [
            DwarfType.Regular : CGRect(origin: CGPoint(x: 16.0/192, y: (352-16)/352), size: CGSize(width: dwarfWidth, height: dwarfHeight))
        ]
    }
}
