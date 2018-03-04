//
//  PulseLaser.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PulseLaser : Turret {
    
    
    override func build() {
        super.build()
        
        if !underConstruction {
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        health_current = health_max
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 1
        power_toUse = 1
        
    }
    
    init(texture: SKTexture, teamID: String = "") {
        super.init(texture: texture, size: StructureSize.large, teamID: teamID)
        
        range = sceneWidth * 0.5
        
        mySprite.name! += "_pulseLaser"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: mySprite.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
