//
//  Reactor.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Reactor : Structure {
    
    
    
    var powerProvided : Int = 10
    
    override func build() {
        super.build()
        
//        if !isBuilding {
//            let normalTexture = SKTexture(image: #imageLiteral(resourceName: "ReactorStage1"))
//        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 10

        // Reactor power priority is low, doesn't need power...
        powerPriority = 0
        powerToBuild = 2
        powerToUse = 0
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: self.size)
        
    }
    
    init(texture: SKTexture) {
        let xy = sceneWidth * 0.12
        let rSize = CGSize(width: xy, height: xy)
        
        let reactorTexture = SKTexture(image: #imageLiteral(resourceName: "test_reactor"))
        
        super.init(texture: reactorTexture, color: .blue, size: rSize)
		self.name = "Reactor"
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
