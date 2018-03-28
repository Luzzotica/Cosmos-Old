//
//  MeleeComponent.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MeleeComponent: GKComponent {
  
    let damage: CGFloat
    let destroySelf: Bool
    let damageRate: CGFloat
    var lastDamageTime: TimeInterval
    let aoe: Bool
    
    let target : Int
  
    init(damage: CGFloat, destroySelf: Bool, damageRate: CGFloat, aoe: Bool, target: Int) {
        self.damage = damage
        self.destroySelf = destroySelf
        self.damageRate = damageRate
        self.aoe = aoe
        self.lastDamageTime = 0
        
        self.target = target
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func update(deltaTime seconds: TimeInterval) {
    
        super.update(deltaTime: seconds)

        // Get the spriteComponent
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        // Get the sprite
        let sprite = spriteComponent.node
        
        // Get the people in contact with me
        let inContactWith = sprite.physicsBody!.allContactedBodies()
        
        var aoeDamageCaused = false
        // Loop through everyone I am in contact with
        for targetSprite in inContactWith {
            // If they have an entity, see if it's the right player
            if let targetEntity = targetSprite.node?.entity {
                guard let enemyPlayerComponent = targetEntity.component(ofType: PlayerComponent.self) else {
                    continue
                }
                
                if enemyPlayerComponent.player == target {
                    // Get the health component of the person we are hitting
                    guard let enemyHealthComponent = targetEntity.component(ofType: HealthComponent.self) else {
                        continue
                    }
                    
                    if (aoe) {
                        aoeDamageCaused = true
                    } else {
                        lastDamageTime = CACurrentMediaTime()
                    }
                    
                    // Subtract health
                    enemyHealthComponent.takeDamage(damage)
                    
                    // Destroy self
                    if destroySelf {
                        EntityManager.shared.remove(entity!)
                    }
                }
                    // If we hit a neutral thing, find out what it is
                else if enemyPlayerComponent.player == 0 {
                    guard let enemyTypeComponent = targetEntity.component(ofType: EntityTypeComponent.self) else {
                        continue
                    }
                    
                    // If we hit an asteroid, remove ourselves, they are unkillable!
                    if enemyTypeComponent.entityType == .asteroid {
                        EntityManager.shared.remove(entity!)
                    }
                }
            }
        }
        
        if (aoeDamageCaused) {
            lastDamageTime = CACurrentMediaTime()
        }
    
        // Loop through enemy entities
        
        guard let enemyEntities = EntityManager.shared.entitiesForPlayer[target] else {
            return
        }
        
        
        for enemyEntity in enemyEntities {
          
            // Get required components
            guard let enemySpriteComponent = enemyEntity.component(ofType: SpriteComponent.self),
                let enemyHealthComponent = enemyEntity.component(ofType: HealthComponent.self) else {
                    continue
            }
          
            // Check for intersection
            if (spriteComponent.node.calculateAccumulatedFrame().intersects(enemySpriteComponent.node.calculateAccumulatedFrame())) {
            
                // Check damage rate
                if (CGFloat(CACurrentMediaTime() - lastDamageTime) > damageRate) {
                  
        //            // Cause damage
        //            spriteComponent.node.parent?.run(sound)
                    if (aoe) {
                        aoeDamageCaused = true
                    } else {
                        lastDamageTime = CACurrentMediaTime()
                    }
                  
                    // Subtract health
                    enemyHealthComponent.takeDamage(damage)
                  
                    // Destroy self
                    if destroySelf {
                        EntityManager.shared.remove(entity!)
                    }
                }
            }
        }
    
        
    
    }
  
}
