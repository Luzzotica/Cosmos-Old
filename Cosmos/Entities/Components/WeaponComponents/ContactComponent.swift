//
//  ContactComponent.swift
//  Cosmos
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class ContactComponent: GKComponent {
  
    let damage: CGFloat
    let destroySelf: Bool
    let damageRate: CGFloat
    var lastDamageTime: TimeInterval
    let aoe: Bool
    let aoeRange: CGFloat
    
    let targets : [Int]
  
    init(damage: CGFloat, destroySelf: Bool, damageRate: CGFloat, aoe: Bool, aoeRange: CGFloat, targets: [Int]) {
        self.damage = damage
        self.destroySelf = destroySelf
        self.damageRate = damageRate
        self.aoe = aoe
        self.aoeRange = aoeRange
        self.lastDamageTime = 0
        
        self.targets = targets
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
//        print("In contact with", inContactWith.count, "Nodes")
        
        var aoeDamageCaused = false
        // Loop through everyone I am in contact with
        for targetSprite in inContactWith {
            // If they have an entity, see if it's the right player
            if let targetEntity = targetSprite.node?.entity {
                guard let enemyPlayerComponent = targetEntity.component(ofType: PlayerComponent.self) else {
                    continue
                }
                
                // Loop through all possible targets that we can hit
                for enemyTarget in targets {
                    // If they are an enemy, execute a hit on them
                    if enemyPlayerComponent.player == enemyTarget {
                        // Get the health component of the person we are hitting
                        guard let enemyHealthComponent = targetEntity.component(ofType: HealthComponent.self) else {
                            continue
                        }
                        
                        if (aoe) {
                            aoeDamageCaused = true
                            //Explosion animation
                            
                            //Get all enemies within explosion radius
                            for enemy in EntityManager.shared.agentComponentsForPlayers(targets)
                            {
                                if (CGPoint(enemy.position) - spriteComponent.node.position).length() < aoeRange
                                {
                                    // Subtract health
                                    if let enemyHealthComponent = enemy.entity?.component(ofType: HealthComponent.self) {
                                        enemyHealthComponent.takeDamage(damage * 0.75)
                                    }
                                }
                            }
                        } else {
                            lastDamageTime = CACurrentMediaTime()
                            // Subtract health
                            enemyHealthComponent.takeDamage(damage)
                        }
                        
                        // Destroy self
                        if destroySelf {
                            EntityManager.shared.remove(entity!)
                        }
                    }
                }
                
                // If we hit a neutral thing, find out what it is
                if enemyPlayerComponent.player == 0 {
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
    
        
    
    }
  
}
