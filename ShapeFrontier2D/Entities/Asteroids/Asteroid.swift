//
//  Asteroid.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Asteroid : Entity {
    
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
    
    init(texture: SKTexture?, gasTexture: SKTexture, size: CGSize, minerals: Int) {
		super.init(texture: texture, color: .blue, size: size)
        
        gasSprite = SKSpriteNode(texture: gasTexture, color: .clear, size: size)
        gasSprite?.zPosition = -1
        addChild(gasSprite!)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionType.Asteroid
        physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.Enemy
        physicsBody?.collisionBitMask = CollisionType.Nothing
        
        zPosition = Layer.Asteroids
        
        health_current = minerals
        health_max = minerals
        
        name! += "_asteroid"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
