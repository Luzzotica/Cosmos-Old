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
        
        let sprite = SpriteComponent(entity: self, texture: texture, size: size)
        sprite.node.name = "entity"
        addComponent(sprite)
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(size.width * 0.5)))
        
        mySprite = sprite.node
        
        health_current = minerals
        health_max = minerals
        
        mySprite.physicsBody = SKPhysicsBody(circleOfRadius: mySprite.size.width * 0.5)
        mySprite.physicsBody?.isDynamic = false
        mySprite.physicsBody?.categoryBitMask = CollisionType.Asteroid
        mySprite.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.Enemy
        mySprite.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        mySprite.zPosition = Layer.Asteroids
        
        mySprite.name! += "_asteroid"
        
        gasSprite = SKSpriteNode(texture: gasTexture, color: .clear, size: mySprite.size)
        gasSprite?.zPosition = -1
        mySprite.addChild(gasSprite!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
