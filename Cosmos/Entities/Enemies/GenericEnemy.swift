//
//  GenericEnemy.swift
//  Cosmos
//
//  Created by Sterling Long on 3/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GenericEnemy : GKEntity {
    
    init(texture: SKTexture, size: CGSize, teamID: Int) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        spriteComponent.node.name = "entity"
        
        addComponent(MoveComponent(maxSpeed: 100, maxAcceleration: 500, radius: Float(size.width * 0.5), name: "Enemy"))
        addComponent(HealthComponent(parentNode: spriteComponent.node, barWidth: size.width, barOffset: size.height * 0.5, health: 50))
        addComponent(PlayerComponent(player: 666))
        addComponent(EntityTypeComponent(type: Type.ship))
        
        let weapon = RocketLauncher_Linear(range: sceneWidth * 0.2, damage: 1.0, damageRate: 0.5, player: 666, targetPlayers: [1])
        weapon.setPossibleTargets(types: .structure)
        
        addComponent(weapon)
        
        // Update his physics body
        spriteComponent.node.physicsBody?.categoryBitMask = CollisionType.Enemy
        spriteComponent.node.physicsBody?.contactTestBitMask = CollisionType.Structure
        spriteComponent.node.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        spriteComponent.spriteNode.zPosition = Layer.Enemies
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
