//
//  Miner.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Miner : Structure {
    
    var miningRange : CGFloat = sceneWidth * 0.2
    var miningAmount = 1
    
    var asteroid_current : Asteroid?
    var asteroid_distance : CGFloat = sceneWidth * 0.2
    
    override func tick(_ currentTime: TimeInterval) {
        super.tick(currentTime)
        if isDisabled {
            return
        }
        
        // Mine the astroid, update HUD with it
        if asteroid_current != nil {
            
            if connection_master != nil
            {
                if power_use(amount: power_toUse, distance: 0) != -1 {
                    PlayerHUDHandler.shared.minerals_Mined(amount: (asteroid_current?.getMineAmount(amount: miningAmount))!)
                    let _ = Laser(entOne: self, entTwo: asteroid_current!, color: .green, width: sceneWidth * 0.005, entityType: EntityType.Miner)
                }
                
                
            }
        }
        
        // If the asteroid is at 0 minerals
        if asteroid_current?.minerals_current == 0 || asteroid_current == nil {
            // And we can't find another asteroid
            if !getAsteroid() {
                print("Couldn't get an asteroid!")
                // We disable ourselves. Nothing to mine =(
                isDisabled = true
                asteroid_current = nil
            }
            // Otherwise, we keep mining cuz we found a cute asteroid!
            print("Got an asteroid!")
        }
    }
    
    func getAsteroid() -> Bool {
        asteroid_distance = miningRange
        var foundAsteroid = false
        
        // Get asteroid in range
        for asteroid in gameScene.asteroidCluster.children {
            // Make sure he has minerals, if he doesn't, skip him
            let asteroid2 = asteroid as? Asteroid
            if asteroid2!.minerals_current == 0 {
                continue
            }
            
            // Otherwise, we continue!
            let values = withinDistance(point1: position, point2: asteroid.position, distance: miningRange)
            
            // If in range, make sure he is the closest
            if values.0 {
                if (values.1)! < asteroid_distance {
                    foundAsteroid = true
                    // If he is, set him up for mining!
                    asteroid_current = asteroid as? Asteroid
                    asteroid_distance = (values.1)!
                }
            }
        }
        
        return foundAsteroid
    }
    
    override func build() {
        super.build()
        
        if !underConstruction {
            texture = Structures.miner
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 1
        power_toUse = 1
        
        // Set up low power overlay
        lowPowerOverlay = SKSpriteNode(texture: Structures.minerLowPower, size: self.size)
        
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: .blue, size: size)
        
        self.name = "Miner"
        
        setupStructure()
        
    }
    
    convenience init(texture: SKTexture) {
        let xy = sceneWidth * 0.05
        let rSize = CGSize(width: xy, height: xy)
        
        self.init(texture: texture, color: .clear, size: rSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
