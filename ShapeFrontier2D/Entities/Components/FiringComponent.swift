//
//  FiringComponent.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FiringComponent: GKComponent {
  
    let range: CGFloat
    let damage: CGFloat
    let damageRate: CGFloat
    var lastDamageTime: TimeInterval
    
    let player : Int
    let targetPlayer : Int
    
    var targetTypes : Set<Type> = Set()
  
    init(range: CGFloat, damage: CGFloat, damageRate: CGFloat, player: Int, targetPlayer: Int) {
        self.range = range
        self.damage = damage
        self.damageRate = damageRate
        self.lastDamageTime = 0
        
        self.player = player
        self.targetPlayer = targetPlayer
        super.init()
    }
    
    func setPossibleTargets(types: Type ...) {
        for type in types {
            targetTypes.insert(type)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func update(deltaTime seconds: TimeInterval) {
    
        super.update(deltaTime: seconds)
    
        // Get required components
        guard let playerComponent = entity?.component(ofType: PlayerComponent.self),
              let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
                return
        }
    
        // Loop through enemy entities
        let enemyEntities = EntityManager.shared.entitiesForPlayer[targetPlayer]!
        for enemyEntity in enemyEntities {
      
            // Get required components
            guard let enemyType = enemyEntity.component(ofType: EntityTypeComponent.self),
                  let enemySpriteComponent = enemyEntity.component(ofType: SpriteComponent.self) else {
                continue
            }
            
            // Make sure we can target them! If we can't, skip them
            if !targetTypes.contains(enemyType.entityType) {
                continue
            }
      
            let distance = (spriteComponent.node.position - enemySpriteComponent.node.position).length()
            let wiggleRoom = CGFloat(5)
            if (CGFloat(abs(distance)) <= range + wiggleRoom && CGFloat(CACurrentMediaTime() - lastDamageTime) > damageRate) {
      
//                spriteComponent.node.parent?.run(sound)
                lastDamageTime = CACurrentMediaTime()
        
                // Create the missile and get his sprite
                let missile = Missile(player: player, target: targetPlayer, damage: damage)
                guard let missileSpriteComponent = missile.component(ofType: SpriteComponent.self) else {
                    continue
                }
        
                // Move the missile to the parets node position
                // I could add anchors to the spriteComponent... like an attack anchor
                missileSpriteComponent.node.position = spriteComponent.node.position
                
                // Get the direction to fire, the speed of the missile, and the distance we want it to travel
                let direction = (enemySpriteComponent.node.position - spriteComponent.node.position).normalized()
                let missilePointsPerSecond = CGFloat(sceneWidth * 0.15)
                let missileDistance = CGFloat(sceneWidth * 1.1)
        
                let targetPosition = direction * missileDistance
                let duration = missileDistance / missilePointsPerSecond
        
                missileSpriteComponent.node.zRotation = direction.angle
                missileSpriteComponent.node.zPosition = 1
        
                missileSpriteComponent.node.run(SKAction.sequence([
                    SKAction.moveBy(x: targetPosition.x, y: targetPosition.y, duration: TimeInterval(duration)),
                    SKAction.run() {
                        EntityManager.shared.remove(missile)
                    }
                    ]))
        
                EntityManager.shared.add(missile)
      
            }
        }
    }
}
