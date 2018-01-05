//
//  Node.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Node : Structure {
    
    override func build() {
        super.build()
        
        if !isBuilding {
            let normalTexture = SKTexture(image: #imageLiteral(resourceName: "NodePwr"))
            texture = normalTexture
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        
        // Reactor power priority is low, doesn't need power...
        powerPriority = 1
        powerToBuild = 1
        powerToUse = 0
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.nodeLowPower, size: self.size)
        
    }
    
    init() {
        let xy = sceneWidth * 0.06
        let rSize = CGSize(width: xy, height: xy)
        
        super.init(texture: Structures.node, color: .blue, size: rSize)
        self.name = "Node"
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
