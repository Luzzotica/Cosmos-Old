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
        health_current = health_max
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 1
        power_toUse = 1
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: self.size)
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: .blue, size: size)
        
        range = sceneWidth * 0.8
        
        setupStructure()
        
        name! += "_missileCannon"
    }
    
    convenience init(texture: SKTexture) {
        let xy = sceneWidth * 0.10
        let rSize = CGSize(width: xy, height: xy)
        
        self.init(texture: texture, color: .clear, size: rSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
