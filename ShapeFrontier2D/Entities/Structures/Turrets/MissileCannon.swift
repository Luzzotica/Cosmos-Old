//
//  Missile Cannon.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class MissileCannon : Turret {
    
    var projectile : Entity!
    
    override func build() {
        super.build()
        
        if !underConstruction {
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 1
        power_toUse = 1
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: self.size)
        
    }
    
    init() {
        let xy = sceneWidth * 0.10
        let rSize = CGSize(width: xy, height: xy)
        
        super.init(texture: Structures.missileCannonLevel1, color: .blue, size: rSize)
        self.name = "MissileCannon"
        
        range = sceneWidth * 0.8
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}