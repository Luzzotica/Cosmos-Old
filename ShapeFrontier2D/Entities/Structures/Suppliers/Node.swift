//
//  Node.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Node : Supplier {
    
    
    
    override func build() {
        super.build()
        
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        health_current = health_max
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 1
        power_toBuild = 1
        power_toUse = 0
        
        
        
    }
    
    init(texture: SKTexture, teamID: String = "") {
        super.init(texture: texture, size: StructureSize.node, teamID: teamID)
        
        mySprite.name! += "_node"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.nodeLowPower, size: mySprite.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
