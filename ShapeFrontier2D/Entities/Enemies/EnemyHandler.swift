//
//  EnemyHandler.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EnemyHandler : NSObject {
    
    static let shared = EnemyHandler()
    
    // Our enemies!
    var enemies : [GKEntity] = []
    private var lastUpdateTime : TimeInterval = 0
    
    // Wave system variables
    var wave_current = 0
    
    func spawnWave() -> [Enemy] {
        var waveToSpawn : [Enemy] = []
        
        waveToSpawn.append(spawnEnemy())
        
        return waveToSpawn
    }
    
    func spawnEnemy() -> Enemy {
        let enemy = Enemy(texture: Enemies.fighter)
        
        // Add their GKEntity to our list so we can update it
        enemies.append(enemy.AI_handler)
        
        return enemy
    }
    
    func update(_ currentTime: TimeInterval) {
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for enemy in self.enemies {
//            print("updating the GKEntity")
            enemy.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func startGame() {
        
    }
    
}
