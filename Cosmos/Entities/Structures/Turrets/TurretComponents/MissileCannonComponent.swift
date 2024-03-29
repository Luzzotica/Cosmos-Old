//
//  MissileCannonComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 4/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MissileCannonComponent: StructureWeaponComponent {
    
    let missileSpeed : Float = 100
    let missileAccel : Float = 1000
    
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
            // Check if we have power, if we don't stop
            if !structureHasPower() {
                return
            }
            
            // Update last time
            lastDamageTime = CACurrentMediaTime()
            
            // Get required components for the missile
            guard let enemySpriteComponent = targetEntity?.component(ofType: SpriteComponent.self),
                let enemyMoveComponent = targetEntity?.component(ofType: MoveComponent.self) else {
                    return
            }
            
            // Create the missile and get his sprite
            let missile = Missile_Tracer(player: player,
                                         targets: targetPlayers,
                                         damage: damage,
                                         maxSpeed: missileSpeed,
                                         maxAcceleration: missileAccel,
                                         target: enemyMoveComponent)
            guard let missileSpriteComponent = missile.component(ofType: SpriteComponent.self),
                let missileTraceComponent = missile.component(ofType: TraceComponent.self) else {
                return
            }
            
            // Move the missile to the parets node position
            // I could add anchors to the spriteComponent... like an attack anchor
            missileSpriteComponent.node.position = spriteComponent.node.position
            
            // Get the direction to fire, the tracing agent should do the rest for us
            let direction = (enemySpriteComponent.node.position - spriteComponent.node.position).normalized()
            
            // Make them start facing the right way
            missileSpriteComponent.spriteNode.zRotation = direction.angle
            missileTraceComponent.rotation = Float(direction.angle)
            
            EntityManager.shared.add(missile)
        }
        
    }
}
