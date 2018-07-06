//
//  Structure2.0.swift
//  Cosmos
//
//  Created by Sterling Long on 7/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

protocol Structure2: GameplayEntity
{
    // MARK: - GameplayEntity Values
    
    var playerID: Int
    var isDisabled: Bool
    
    func select()
    func deselect()
    
    func didDied()
    
    // MARK: - Structure Values
    
    var level: Int { get set }
    
    var isBuilt: Bool { get set }
    var isSupplier: Bool { get set }
    
    var constructionCost: Int { get }
    
    var powerComponent: PowerComponent { get set }
    
    func recycle()
    func didFinishPlacement()
    func didFinishConstruction()
    
    func upgrade_start()
    func upgrade_finish()
    func upgrade_setLevel(level: Int)
    func update_isMaxLevel() -> Bool
    
}

extension Structure2
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

