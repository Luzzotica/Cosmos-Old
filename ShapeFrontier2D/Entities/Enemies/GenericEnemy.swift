//
//  Enemy.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GenericEnemy : GKEntity {
    
    init(texture: SKTexture, size: CGSize, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        addComponent(MoveComponent(maxSpeed: 2.5, maxAcceleration: 1, radius: Float(texture.size().width * 0.05)))
        addComponent(HealthComponent(parentNode: spriteComponent.node, barWidth: size.width, barOffset: size.height * 0.5, health: 50))
        addComponent(TeamComponent(team: team))
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
