//
//  GameEntity.swift
//  Cosmos
//
//  Created by Sterling Long on 7/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

protocol GameplayEntity
{
    
    var playerID: Int { get set }
    var isDisabled: Bool { get set }
    
    func select()
    func deselect()
    
    func didDied()
    
}

extension GameplayEntity
{
    static func setupSprite(texture: SKTexture, size: CGSize) -> SpriteComponent
    {
        // Add a sprite
        let spriteComponent = SpriteComponent(texture: texture, size: size)
        
        spriteComponent.node.physicsBody?.categoryBitMask = CollisionType.Structure
        spriteComponent.node.physicsBody?.contactTestBitMask = CollisionType.Structure
        spriteComponent.node.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        spriteComponent.node.zPosition = Layer.Player
        
        return spriteComponent
    }
}
