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
        
        if !underConstruction {
            let normalTexture = SKTexture(image: #imageLiteral(resourceName: "NodePwr"))
            texture = normalTexture
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 1
        power_toBuild = 1
        power_toUse = 0
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.nodeLowPower, size: self.size)
        
    }
    
    init() {
        let x = sceneWidth * 0.015
        let y = sceneWidth * 0.03
        let rSize = CGSize(width: x, height: y)
        
        super.init(texture: Structures.node, color: .blue, size: rSize)
        self.name = "Node"
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
