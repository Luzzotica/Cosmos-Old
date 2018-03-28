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

class Missile: GKEntity {
    
    var mySprite : SKSpriteNode!

    init(player: Int, target: Int, damage: CGFloat) {
    
        super.init()
    
        let size = CGSize(width: sceneWidth * 0.01, height: sceneWidth * 0.01)
        let spriteComponent = SpriteComponent(entity: self, size: size)
        addComponent(spriteComponent)
        addComponent(PlayerComponent(player: player))
        addComponent(MeleeComponent(damage: damage,
                                    destroySelf: true,
                                    damageRate: 1.0,
                                    aoe: false,
                                    target: target))
        addComponent(EntityTypeComponent(type: Type.missile))
        
        mySprite = spriteComponent.node
        
        mySprite.physicsBody?.categoryBitMask = CollisionType.StructureMissile
        mySprite.physicsBody?.collisionBitMask = CollisionType.Nothing

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
