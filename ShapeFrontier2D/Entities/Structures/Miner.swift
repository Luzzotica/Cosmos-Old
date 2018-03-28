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
    
    var asteroid_current : Asteroid?
    var asteroid_distance : CGFloat = sceneWidth * 0.2
    
    override func tick() {
        if isDisabled {
            return
        }
        
        // Increase the tick
        tick_count += 1
        if tick_count <= tick_action {
            return
        }
        
        super.tick()
        
        // If we don't have enough power in the global power, show that we are out of power
        if gameScene.player_powerCurrent < power_toUse {
            return
        }
        
        //If it's time to take action..
        // Reset tick count
        tick_count = 0
        // Mine the astroid, update HUD with it
        if asteroid_current != nil {
            if connection_master != nil
            {
                let ID = Structure.power_prepareFind()
//                print("Find ID is: \(ID)")
                
                // Find power!
                if power_find(amount: power_toUse, distance: 0, dontLookAtID: Structure.dontLookAtID) != -1 {
                    gameScene.minerals_current += (asteroid_current?.getMineAmount(amount: damage))!
                    let _ = Laser(entOne: self, entTwo: asteroid_current!, color: .green, width: sceneWidth * 0.005)
                }
                else {
//                    print("Current master: \(connection_master!.name)")
                }
                
                Structure.power_finishedFind(findID: ID)
            }
        }
        
        // If the asteroid is at 0 minerals or if the miner doesn't have an asteroid
        if asteroid_current?.health_current == 0 || asteroid_current == nil {
            // And we can't find another asteroid
            if !getAsteroid() {
                print("Couldn't find an asteroid in range!")
                // We disable ourselves. Nothing to mine =(
                isDisabled = true
                asteroid_current = nil
            }
        }
        
    }
    
    func getAsteroid() -> Bool {
        asteroid_distance = miningRange
        var foundAsteroid = false
        
        // Get asteroid in range
        for asteroid in gameScene.asteroidCluster {
            // Make sure he has minerals, if he doesn't, skip him
            if asteroid.health_current == 0 {
                continue
            }
            
            // Otherwise, we continue!
            let values = withinDistance(point1: mySprite.position, point2: asteroid.mySprite.position, distance: miningRange)
            
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
        
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        health_current = health_max
        
        // Damage = mining amount
        damage = 10
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 1
        power_toUse = 5
    }
    
    init(texture: SKTexture, team: Team) {
        
        super.init(texture: texture, size: StructureSize.small, team: team)
        
        mySprite.name! += "_miner"
        
        power_lowOverlay = SKSpriteNode(texture: Structures.minerLowPower, size: mySprite.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
