//
//  Lasser.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Missile_Linear: GKEntity {
    
    var mySprite : SKSpriteNode!
    var myNode : SKNode!

    init(player: Int, targets: [Int], damage: CGFloat, sprite: SKTexture? = nil) {
        
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
                                    aoe: false,
                                    targets: targets))
        addComponent(EntityTypeComponent(type: Type.missile))
        
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
