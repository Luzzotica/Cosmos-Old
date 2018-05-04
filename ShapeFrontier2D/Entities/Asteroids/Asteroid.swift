//
//  Asteroid.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Asteroid : GKEntity {
    
    var gasSprite : SKSpriteNode?
    
    init(texture: SKTexture, gasTexture: SKTexture, size: CGSize, minerals: Int) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        
        spriteComponent.node.physicsBody?.isDynamic = false
        spriteComponent.node.physicsBody?.categoryBitMask = CollisionType.Asteroid
        spriteComponent.node.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.Enemy
        spriteComponent.node.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        spriteComponent.node.zPosition = Layer.Asteroids
        
        spriteComponent.node.name = "entity"
        spriteComponent.node.name! += "_asteroid"
        
        let gasSpriteSize = CGSize(width: spriteComponent.spriteNode.size.width * 0.9, height: spriteComponent.spriteNode.size.height * 0.9)
        gasSprite = SKSpriteNode(texture: gasTexture, color: .clear, size: gasSpriteSize)
        gasSprite?.zPosition = -1
        spriteComponent.node.addChild(gasSprite!)
        
        addComponent(spriteComponent)
        addComponent(AsteroidComponent(minerals: minerals, gasSprite: gasSprite!))
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(size.width * 0.5), name: "Asteroid"))
        addComponent(TeamComponent(team: .team3))
        addComponent(PlayerComponent(player: 0))
        addComponent(EntityTypeComponent(type: Type.asteroid))
        
        // Obstacle component so that the unit will avoid it!
        addComponent(ObstacleComponent(position: float2(spriteComponent.node.position),
                                       radius: Float(size.width * 0.5)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
