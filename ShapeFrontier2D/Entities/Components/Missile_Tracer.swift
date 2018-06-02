//
//  Missile_Tracer.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Missile_Tracer: GKEntity {
    
    var mySprite : SKSpriteNode!
    var myNode : SKNode!
    
    init(player: Int, targets: [Int], damage: CGFloat, maxSpeed: Float, maxAcceleration: Float, target: GKAgent2D, sprite: SKTexture? = nil) {
        
        super.init()
        
        let size = CGSize(width: sceneWidth * 0.01, height: sceneWidth * 0.01)
        var spriteComponent : SpriteComponent
        if sprite == nil {
            spriteComponent = SpriteComponent(entity: self, size: size)
        }
        else {
            spriteComponent = SpriteComponent(entity: self, texture: sprite!, size: size)
        }
        
        addComponent(spriteComponent)
        addComponent(PlayerComponent(player: player))
        addComponent(ContactComponent(damage: damage,
                                      destroySelf: true,
                                      damageRate: 1.0,
                                      aoe: true,
                                      aoeRange: size.width * 6,
                                      targets: targets))
        addComponent(EntityTypeComponent(type: Type.missile))
        
        addComponent(TraceComponent(maxSpeed: maxSpeed,
                                    maxAcceleration: maxAcceleration,
                                    radius: Float(size.width),
                                    target: target))
        addComponent(HealthComponent(parentNode: spriteComponent.node, barWidth: 0, barOffset: 0, health: 1, showHealth: false))
        
        mySprite = spriteComponent.spriteNode
        myNode = spriteComponent.node
        mySprite.zPosition = Layer.Projectiles
        
        myNode.physicsBody?.categoryBitMask = CollisionType.Missile
        myNode.physicsBody?.contactTestBitMask = CollisionType.Structure |
            CollisionType.Asteroid |
            CollisionType.Enemy
        myNode.physicsBody?.collisionBitMask = CollisionType.Nothing
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
