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
    
    override func tick(_ currentTime: TimeInterval) {
        super.tick(currentTime)
        if isDisabled {
            return
        }
        if power_current < power_capacity
        {
            power_current += powerProvided
            print("Local power is: \(power_current)")
            gameScene.power_add(toAdd: powerProvided)
        }
    }
    
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
        
        power_capacity = 100
        power_current = 100
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: self.size)
    }
    
    override func didFinishConstruction() {
        super.didFinishConstruction()
        //Update overall energy variables
        gameScene.power_capacity += power_capacity
        gameScene.power_current += power_current
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: .blue, size: size)
        
        self.name = "Reactor"
        
        setupStructure()
        
        connection_distance = 0
        
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
