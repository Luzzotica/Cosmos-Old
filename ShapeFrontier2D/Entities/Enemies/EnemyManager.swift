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

class EnemyManager : NSObject {
    
    static let shared = EnemyManager()
    
    // Our enemies!
    var enemies : [GKEntity] = []
    private var lastUpdateTime : TimeInterval = 0
    
    // Wave system variables
    var wave_current = 0
    
    func spawnWave() -> [GenericEnemy] {
        var waveToSpawn : [GenericEnemy] = []
        
        waveToSpawn.append(createEnemy())
        
        
        return waveToSpawn
    }
    
    func createEnemy() -> GenericEnemy {
        let size = CGSize(width: sceneWidth * 0.05, height: sceneWidth * 0.05)
        let enemy = GenericEnemy(texture: Enemies.fighter, size: size, team: .team2)
        
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
