//
//  Reactor.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Reactor : Supplier {
    
    
    
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
        power_priority = 0
        power_toBuild = 2
        power_toUse = 0
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: self.size)
        
    }
    
    init() {
        let xy = sceneWidth * 0.10
        let rSize = CGSize(width: xy, height: xy)
        
        super.init(texture: Structures.reactorLevel1, color: .blue, size: rSize)
        self.name = "Reactor"
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
