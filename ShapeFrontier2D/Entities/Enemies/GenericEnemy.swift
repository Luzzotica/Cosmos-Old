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
    var myNode : SKNode!
    
    init(texture: SKTexture, size: CGSize, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        mySprite = spriteComponent.spriteNode
        myNode = spriteComponent.node
        myNode.name = "entity"
        
        addComponent(MoveComponent(maxSpeed: 100, maxAcceleration: 500, radius: Float(size.width * 0.5), name: "Enemy"))
        addComponent(HealthComponent(parentNode: mySprite, barWidth: size.width, barOffset: size.height * 0.5, health: 50))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 666))
        addComponent(EntityTypeComponent(type: Type.ship))
        
        let weapon = RocketLauncher_Linear(range: sceneWidth * 0.2, damage: 1.0, damageRate: 0.5, player: 666, targetPlayers: [1])
        weapon.setPossibleTargets(types: .structure)
        
        addComponent(weapon)
        
        // Update his physics body
        myNode.physicsBody?.categoryBitMask = CollisionType.Enemy
        myNode.physicsBody?.contactTestBitMask = CollisionType.Structure
        myNode.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        mySprite.zPosition = Layer.Enemies
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
