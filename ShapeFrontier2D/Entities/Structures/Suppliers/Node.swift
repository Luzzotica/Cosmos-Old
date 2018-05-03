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
        
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        health_current = health_max
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 1
        power_toBuild = 1
        power_toUse = 0
        
        
        
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: StructureSize.node, team: team)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(mySprite!.size.width * 0.5), name: "Node"))
        addComponent(HealthComponent(parentNode: mySprite, barWidth: mySprite!.size.width * 0.5, barOffset: mySprite!.size.height * 0.61, health: 50))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        myNode.name! += "_node"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.nodeLowPower, size: mySprite.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
