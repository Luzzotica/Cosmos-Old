//
//  Miner.swift
//  Cosmos
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
    
    // MARK: - Upgrade Functions
    
    override func upgrade_start() {
        super.upgrade_start()
        
        let upgradeComponent = UpgradeComponent(ticks: Structure.MinerValues.upgrade_ticks[level],
                                                power: Structure.MinerValues.power_toUpgrade)
        
        // Add the component to ourselves
        addComponent(upgradeComponent)
        
        // Add the component to the entity manager
        EntityManager.shared.addComponent(component: upgradeComponent)
    }
    
    override func upgrade_finish() {
        super.upgrade_finish()
        
    }
    
    override func upgrade_setLevel(level: Int) {
        self.level = level
        
        // Change his health
        if let healthComponent = component(ofType: HealthComponent.self) {
            healthComponent.setMaxHealth(Structure.MinerValues.maxHealth[level])
        }
        
        // Change his sprite
        if let spriteComponent = component(ofType: SpriteComponent.self) {
            spriteComponent.setSpriteTexture(texture: Structure.Textures.miner)
        }
    }
    
    override func upgrade_isMaxLevel() -> Bool {
        return level >= Structure.MinerValues.level_max
    }
    
    override func tick() {
        super.tick()
        
        if isDisabled || !isBuilt {
            return
        }
        
        // Increase the tick
        tick_count += 1
        if tick_count <= tick_action {
            return
        }
        
        // If we don't have enough power in the global power, show that we are out of power
        if PlayerManager.shared.players[playerID]!.power_getCurrent() < power_toUse {
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
                if power_find(amount: power_toUse, distance: 0, dontLookAtID: ID) != -1 {
                    let asteroidComponent = asteroid_current?.component(ofType: AsteroidComponent.self)
                    PlayerManager.shared.players[playerID]!.minerals += asteroidComponent!.getMineAmount(amount: Structure.MinerValues.damage[level])
                    let nodeOne = component(ofType: SpriteComponent.self)!.node
                    let nodeTwo = asteroid_current?.component(ofType: SpriteComponent.self)!.node
                    let laser = Laser(nodeOne: nodeOne, nodeTwo: nodeTwo!, color: .green, width: sceneWidth * 0.005)
                    nodeOne.addChild(laser)
                    laser.animate(animationType: 0)
                }
                else {
//                    print("Current master: \(connection_master!.name)")
                }
                
                Structure.power_finishedFind(findID: ID)
            }
        }
        
        // If the asteroid is at 0 minerals or if the miner doesn't have an asteroid
        let asteroidComponent = asteroid_current?.component(ofType: AsteroidComponent.self)
        if asteroidComponent == nil || asteroidComponent!.minerals_current == 0 || asteroid_current == nil {
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
            let asteroidComponent = asteroid.component(ofType: AsteroidComponent.self)
            if asteroidComponent!.minerals_current == 0 {
                continue
            }
            
            // Otherwise, we continue!
            let spriteComponent = component(ofType: SpriteComponent.self)
            let asteroidSpriteComponent = asteroid.component(ofType: SpriteComponent.self)
            let values = withinDistance(point1: spriteComponent!.node.position,
                                        point2: asteroidSpriteComponent!.node.position,
                                        distance: miningRange)
            
            // If in range, make sure he is the closest
            if values.0 {
                if (values.1)! < asteroid_distance {
                    foundAsteroid = true
                    // If he is, set him up for mining!
                    asteroid_current = asteroid
                    asteroid_distance = (values.1)!
                }
            }
        }
        
        return foundAsteroid
    }
    
    override func select() {
        // Create a range indicator for ourselves
        let range = UIHandler.shared.createRangeIndicator(range: miningRange, color: .green)
        
        // Get the sprite component
        let spriteComponent = component(ofType: SpriteComponent.self)
        spriteComponent!.select(toAdd: [range])
    }
    
    // MARK: - Construction
    
    override func didFinishPlacement() {
        super.didFinishPlacement()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.MinerValues.build_ticks, power: Structure.MinerValues.power_toBuild))
    }
    
    init(playerID: Int) {
        
        super.init(texture: Structure.Textures.miner, size: Structure.Size.small, playerID: playerID)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Miner"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node,
                                     barWidth: spriteComponent!.spriteNode.size.width * 0.5,
                                     barOffset: spriteComponent!.spriteNode.size.height * 0.61,
                                     health: Structure.MinerValues.maxHealth[level]))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_miner"
        
        power_lowOverlay = SKSpriteNode(texture: Structure.Textures.minerLowPower, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        power_toUse = Structure.MinerValues.power_toUse
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
