//
//  EnemyDetectorComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/30/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class EnemyIndicatorManager : SKNode {
    
    var enemyIndicators : [GKEntity:EnemyIndicator] = [:]
    
    override init() {
        super.init()
    }
    
    func removeEnemy(_ enemy: GKEntity) {
        print("Got here")
        
        // Remove the line
        enemyIndicators[enemy]?.removeFromParent()
        
        // Remove the key value pair
        enemyIndicators.removeValue(forKey: enemy)
    }
    
    func update(player: PlayerEntity) {
        // Loop through all indicators, update them
        for (_, indicator) in enemyIndicators {
            indicator.update()
        }
        
        // Sanity check, if the entity doesn't exist, do nothing
        // Also make sure they are
//        if entity == nil && entity is PlayerEntity {
//            print("This shouldn't happen!")
//            return
//        }
        
        // Search for all enemies, create a little indicator towards their sprite in game
//        let player = (entity as! PlayerEntity)
        let indicatorSize = CGSize(width: sceneWidth * 0.03, height: sceneWidth * 0.04)
        let indicatorOffset : CGFloat = sceneWidth * 0.06
        
        // Loop through all of the enemies our player has
        for enemy in player.enemies {
            // Get the entities for that player
            let enemiesForPlayer = EntityManager.shared.entitiesForPlayer[enemy]
            
            // If that player has no entities, continue on our way
            if enemiesForPlayer == nil {
                continue
            }
            
            // Create a sprite towards each of the enemies
            for enemy in enemiesForPlayer! {
                // If we have already added them to our indicators, we continue
                if enemyIndicators[enemy] != nil {
                    continue
                }
                
                // If they have a sprite component
                guard let enemySpriteComponent = enemy.component(ofType: SpriteComponent.self),
                    let enemyType = enemy.component(ofType: EntityTypeComponent.self) else {
                    continue
                }
                
                // Check their type, only draw an indicator to them if they are not a missile
                if enemyType.entityType == .missile {
                    continue
                }
                
                // Make an indicator towards them
                let line = EnemyIndicator(target: enemySpriteComponent.node)
                line.anchorPoint.x = 0.0
                
                addChild(line)
                
                enemyIndicators[enemy] = line
                
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
