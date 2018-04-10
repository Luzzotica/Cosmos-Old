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
    
    var health_max : Int = 0
    var health_current : Int = 0
    
    var mySprite: SKSpriteNode!
    var gasSprite : SKSpriteNode?
    
    func getMineAmount(amount: Int) -> Int {
        var amountMined = 0
        if amount > health_current {
            amountMined = health_current
            health_current = 0
            gasSprite?.alpha = 0.0
        }
        else {
            amountMined = amount
            health_current -= amount
            gasSprite?.alpha = CGFloat(health_current) / CGFloat(health_max)
        }
        
        return amountMined
    }
    
    init(texture: SKTexture, gasTexture: SKTexture, size: CGSize, minerals: Int) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        mySprite = spriteComponent.node
        
        mySprite.physicsBody?.isDynamic = false
        mySprite.physicsBody?.categoryBitMask = CollisionType.Asteroid
        mySprite.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.Enemy
        mySprite.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        mySprite.zPosition = Layer.Asteroids
        
        mySprite.name = "entity"
        mySprite.name! += "_asteroid"
        
        let gasSpriteSize = CGSize(width: mySprite.size.width * 0.9, height: mySprite.size.height * 0.9)
        gasSprite = SKSpriteNode(texture: gasTexture, color: .clear, size: gasSpriteSize)
        gasSprite?.zPosition = -1
        mySprite.addChild(gasSprite!)
        
        addComponent(spriteComponent)
        addComponent(AsteroidComponent(minerals: minerals, gasSprite: gasSprite!))
        addComponent(ObstacleComponent(position: mySprite.position, radius: size.width * 0.5))
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(size.width * 0.5), name: "Asteroid"))
        addComponent(TeamComponent(team: .team3))
        addComponent(PlayerComponent(player: 0))
        addComponent(EntityTypeComponent(type: Type.asteroid))
        
        health_current = minerals
        health_max = minerals
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
