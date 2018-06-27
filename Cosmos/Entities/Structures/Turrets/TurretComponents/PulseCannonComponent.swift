//
//  PulseCannonComponent.swift
//  Cosmos
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
            // Check if we have power, if we don't stop
            if !structureHasPower() {
                return
            }
            
            // Update last time
            lastDamageTime = CACurrentMediaTime()
            
            // Deal damage to the target!
            if let targetHealth = targetEntity?.component(ofType: HealthComponent.self) {
                targetHealth.takeDamage(damage)
            }
            
            let nodeOne = entity!.component(ofType: SpriteComponent.self)!.node
            let nodeTwo = targetEntity!.component(ofType: SpriteComponent.self)!.node
            
            // Create a lazer!
            let laser = Laser(nodeOne: nodeOne, nodeTwo: nodeTwo, color: .yellow, width: width)
            nodeOne.addChild(laser)
            laser.animate(animationType: 0)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
