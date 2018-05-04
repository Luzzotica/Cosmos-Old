//
//  LaserTurret.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/28/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class PulseCannonComponent : StructureWeaponComponent {
    
    let width : CGFloat = 3.0
    
    override init(range: CGFloat, damage: CGFloat, damageRate: CGFloat, player: Int, targetPlayers: [Int]) {
        super.init(range: range, damage: damage, damageRate: damageRate, player: player, targetPlayers: targetPlayers)
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
            
            // Deal damage to the target!
            if let targetHealth = targetEntity?.component(ofType: HealthComponent.self) {
                targetHealth.takeDamage(damage)
            }
            
            // Create a lazer!
            let _ = Laser(entOne: entity!, entTwo: targetEntity!, color: .yellow, width: width)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
