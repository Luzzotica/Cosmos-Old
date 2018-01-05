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
        
        if !isBuilding {
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        
        // Reactor power priority is low, doesn't need power...
        powerPriority = 0
        powerToBuild = 1
        powerToUse = 1
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: self.size)
        
    }
    
    init(texture: SKTexture) {
        let xy = sceneWidth * 0.12
        let rSize = CGSize(width: xy, height: xy)
        
        let texture = SKTexture(image: #imageLiteral(resourceName: "test_reactor"))
        
        super.init(texture: texture, color: .blue, size: rSize)
		self.name = "Laser"
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
