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
    
    var minerals_current : Int = 0
    
    init(texture: SKTexture?, size: CGSize, minerals: Int) {
		super.init(texture: texture, color: .blue, size: size)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionType.Asteroid
        physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.Enemy
        physicsBody?.collisionBitMask = CollisionType.Nothing
        
        zPosition = Layer.Asteroids
        
        minerals_current = minerals
        
        name = "asteroid"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
