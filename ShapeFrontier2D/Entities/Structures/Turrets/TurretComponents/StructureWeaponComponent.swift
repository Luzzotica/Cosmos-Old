//
//  WeaponComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class StructureWeaponComponent : GKComponent {
    
    let range : CGFloat
    let damage : CGFloat
    let damageRate : CGFloat
    var lastDamageTime : TimeInterval
    
    let player : Int
    let targetPlayers : [Int]
    
    var power_toUse : Int
    
    weak var targetEntity : GKEntity?
    
    init(range: CGFloat, damage: CGFloat, damageRate: CGFloat, player: Int, targetPlayers: [Int]) {
        self.range = range
        self.damage = damage
        self.damageRate = damageRate
        self.lastDamageTime = 0
        
        self.player = player
        self.targetPlayers = targetPlayers
        super.init()
    }
    
    func setPossibleTargets(types: Type ...) {
        for type in types {
            targetTypes.insert(type)
        }
    }
    
    func canShoot() -> Bool {
        
    }
    
    func currentTargetValid(currentPos: CGPoint) -> Bool {
        // If we have a current target
        if targetEntity != nil {
            // Make sure the currect target is still within range
            guard let enemySpriteComponent = targetEntity!.component(ofType: SpriteComponent.self) else { return false }
            
            // Get the distance between us and the current target
            let distance = (currentPos - enemySpriteComponent.node.position).length()
            let wiggleRoom = CGFloat(5)
            // If it's still within the correct distance, stop, don't get a new target
            if CGFloat(abs(distance)) <= range + wiggleRoom {
//                print("Target Valid")
                return true
            }
        }
        
        // Remove him as a target
        if targetEntity != nil {
            targetEntity = nil
        }
        
        return false
    }
    
    func getClosestEnemyInRange() {
        // Get required components
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        var target : GKEntity?
        var minDistance : CGFloat = range
        
        // Loop through the players we want to target
        for enemyPlayer in targetPlayers {
            
            // Loop through enemy entities
            let enemyEntities = EntityManager.shared.entitiesForPlayer[enemyPlayer]!
            for enemyEntity in enemyEntities {
                
                // Get required components, otherwise, continue
                guard let enemyType = enemyEntity.component(ofType: EntityTypeComponent.self),
                    let enemySpriteComponent = enemyEntity.component(ofType: SpriteComponent.self) else {
                        continue
                }
                
                // Make sure we can target them! If we can't, skip them
                if !targetTypes.contains(enemyType.entityType) {
                    continue
                }
                
                // Get the closest target
                let distance = (spriteComponent.node.position - enemySpriteComponent.node.position).length()
                if distance <= minDistance {
                    target = enemyEntity
                    minDistance = distance
                }
            }
        }
        
        targetEntity = target
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
