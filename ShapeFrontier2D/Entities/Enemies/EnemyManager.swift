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
        
        // Get a random rotation and distance
        let radius = sceneWidth * 3.5
        let angle = Double(arc4random_uniform(361))
        let spawnPoint = CGPoint(x: CGFloat(cos(angle) * Double(radius)), y: CGFloat((sin(angle) * Double(radius))))
        
        // Create the wave
        waveToSpawn = createWave(atPoint: spawnPoint)
        
        // Return the wave needing spawning
        return waveToSpawn
    }
    
    func createWave(atPoint: CGPoint) -> [GenericEnemy] {
        var waveToSpawn : [GenericEnemy] = []
        
        // Just make 10 enemies for now
        for _ in 0...10 {
            // Get random angle and distance from center
            let radius = Double(arc4random_uniform(UInt32(sceneWidth * 0.6)))
            let angle = Double(arc4random_uniform(361))
            var spawnPoint = CGPoint(x: CGFloat(cos(angle) * Double(radius)), y: CGFloat((sin(angle) * Double(radius))))
            spawnPoint += atPoint
            
            waveToSpawn.append(createEnemy(atPoint: spawnPoint))
        }
        
        // Return out beautiful wave of fresh enemies
        return waveToSpawn
    }
    
    func createEnemy(atPoint: CGPoint) -> GenericEnemy {
        let size = CGSize(width: sceneWidth * 0.05, height: sceneWidth * 0.05)
        let enemy = GenericEnemy(texture: Enemies.fighter, size: size, team: .team2)
        
        // Move him to the proper point
        enemy.mySprite.position = atPoint
        
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
