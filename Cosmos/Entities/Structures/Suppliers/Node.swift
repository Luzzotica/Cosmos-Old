//
//  Node.swift
//  Cosmos
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Node : Supplier {
    
    override func didFinishPlacement() {
        super.didFinishPlacement()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.NodeValues.build_ticks, power: Structure.NodeValues.power_toBuild))
    }
    
    init(playerID: Int) {
        super.init(texture: Structure.Textures.node, size: Structure.Size.node, playerID: playerID)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Node"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node,
                                     barWidth: spriteComponent!.spriteNode.size.width * 0.5,
                                     barOffset: spriteComponent!.spriteNode.size.height * 0.61,
                                     health: Structure.NodeValues.maxHealth))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_node"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structure.Textures.nodeLowPower, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
