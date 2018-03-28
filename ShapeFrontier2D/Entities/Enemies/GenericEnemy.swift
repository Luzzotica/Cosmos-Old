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
    
    var mySprite : SKSpriteNode!
    
    init(texture: SKTexture, size: CGSize, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        mySprite = spriteComponent.node
        mySprite.name = "entity"
        
        addComponent(MoveComponent(maxSpeed: 5.0, maxAcceleration: 1, radius: Float(size.width * 0.5), name: "Enemy"))
        addComponent(HealthComponent(parentNode: mySprite, barWidth: size.width, barOffset: size.height * 0.5, health: 50))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 666))
        addComponent(EntityTypeComponent(type: Type.ship))
        
        let weapon = FiringComponent(range: sceneWidth * 0.2, damage: 0.1, damageRate: 0.1, player: 666, targetPlayer: 1)
        weapon.setPossibleTargets(types: .structure)
        
        addComponent(weapon)
        
        // Update his physics body
        mySprite.physicsBody?.categoryBitMask = CollisionType.Enemy
        mySprite.physicsBody?.contactTestBitMask = CollisionType.Structure
        mySprite.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        mySprite.zPosition = Layer.Enemies
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
