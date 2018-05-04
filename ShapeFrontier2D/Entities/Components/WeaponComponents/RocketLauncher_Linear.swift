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

class RocketLauncher_Linear: WeaponComponent {
    
    override init(range: CGFloat, damage: CGFloat, damageRate: CGFloat, player: Int, targetPlayers: [Int]) {
        super.init(range: range, damage: damage, damageRate: damageRate, player: player, targetPlayers: targetPlayers)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        if CGFloat(CACurrentMediaTime() - lastDamageTime) <= damageRate {
            return
        }
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else { return }
        
        // If the current target is invalid, then we get a new one
        if !currentTargetValid(currentPos: spriteComponent.node.position) {
            getClosestEnemyInRange()
        }
        
        // If we have a target, attack him!
        if targetEntity != nil {
            // Update last time
            lastDamageTime = CACurrentMediaTime()
            
            // Get required components for the missile
            guard let enemySpriteComponent = targetEntity?.component(ofType: SpriteComponent.self) else {
                return
            }
            
            // Create the missile and get his sprite
            let missile = Missile_Linear(player: player, targets: targetPlayers, damage: damage)
            guard let missileSpriteComponent = missile.component(ofType: SpriteComponent.self) else {
                return
            }
            
            // Move the missile to the parent's node position
            // I could add anchors to the spriteComponent... like an attack anchor
            missileSpriteComponent.node.position = spriteComponent.node.position
            
            // Get the direction to fire, the speed of the missile, and the distance we want it to travel
            let direction = (enemySpriteComponent.node.position - spriteComponent.node.position).normalized()
            let missilePointsPerSecond = CGFloat(sceneWidth * 0.15)
            let missileDistance = CGFloat(sceneWidth * 1.1)
            
            let targetPosition = direction * missileDistance
            let duration = missileDistance / missilePointsPerSecond
            
            missileSpriteComponent.spriteNode.zRotation = direction.angle
            missileSpriteComponent.spriteNode.zPosition = 1
            
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
