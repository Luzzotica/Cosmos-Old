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
        let overlayTexture = SKTexture(image: #imageLiteral(resourceName: "NodeNoPwr"))
        lowPowerOverlay = SKSpriteNode(texture: overlayTexture, size: self.size)
        
    }
    
    init() {
        let xy = sceneWidth * 0.04
        let rSize = CGSize(width: xy, height: xy)
        
        let nodeTexture = SKTexture(image: #imageLiteral(resourceName: "NodeNoPwr"))
        
        super.init(texture: nodeTexture, color: .blue, size: rSize)
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
