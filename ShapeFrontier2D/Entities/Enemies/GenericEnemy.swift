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
        
//        let sprite = SKSpriteNode(texture: texture, color: .clear, size: size)
        
//        let node = GKSKNodeComponent(node: sprite)
//        addComponent(node)
        
//        let agent = MoveComponent(maxSpeed: 5.0, maxAcceleration: 1, radius: Float(texture.size().width * 0.05), name: "Enemy")
//        agent.delegate = node
        
//        addComponent(agent)
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        addComponent(spriteComponent)
        mySprite = spriteComponent.node
        mySprite.name = "entity"
        
        addComponent(MoveComponent(maxSpeed: 5.0, maxAcceleration: 1, radius: Float(size.width * 0.5), name: "Enemy"))
        addComponent(HealthComponent(parentNode: mySprite, barWidth: size.width, barOffset: size.height * 0.5, health: 50))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 666))
        
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
