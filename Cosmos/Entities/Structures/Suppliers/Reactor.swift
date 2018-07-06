//
//  Reactor.swift
//  Cosmos
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class Reactor: GKEntity, Structure2
{
    
    // MARK: - Properties
    
    var playerID: Int
    
    var powerStorageComponent: PowerStorageComponent
    {
        if let storageComponent = component(ofType: PowerStorageComponent.self)
        {
            return storageComponent
        }
        else
        {
            fatalError("Reactor must have powerStorageComponent!")
        }
    }
    
    func recycle() {
        PlayerManager.shared.players[playerID]!.minerals += Int(CGFloat(constructionCost) * 0.75)
    }
    
    // MARK: - Upgrade Functions
    
    func upgrade_start()
    {
        let upgradeComponent = UpgradeComponent(ticks: Structure.ReactorValues.upgrade_ticks[level],
                                                power: Structure.ReactorValues.power_toUpgrade)
        
        // Add the component to ourselves
        addComponent(upgradeComponent)
        
        // Add the component to the entity manager
        EntityManager.shared.addComponent(component: upgradeComponent)
    }
    
    func upgrade_finish() {}
    
    func upgrade_setLevel(level: Int)
    {
        self.level = level
        
        // Change his health
        if let healthComponent = component(ofType: HealthComponent.self)
        {
            healthComponent.setMaxHealth(Structure.ReactorValues.maxHealth[level])
        }
        
        // Change his sprite
        if let spriteComponent = component(ofType: SpriteComponent.self)
        {
            spriteComponent.setSpriteTexture(texture: Structure.Textures.reactor[level])
        }
    }
    
    func upgrade_isMaxLevel() -> Bool
    {
        return level >= Structure.ReactorValues.level_max
    }
    
//    override func tick() {
//        super.tick()
//
//        if isDisabled || !isBuilt {
//            return
//        }
//
//        if power_current < Structure.ReactorValues.power_capacity[level]
//        {
//            power_current += Structure.ReactorValues.power_provided[level]
//            // If the power is greater than his capacity, then we cap it, and add to the game scene what was added
//            if power_current > Structure.ReactorValues.power_capacity[level] {
//                let powerOver = power_current - Structure.ReactorValues.power_capacity[level]
//                PlayerManager.shared.players[playerID]?.power_current += Structure.ReactorValues.power_provided[level] - powerOver
//                power_current = Structure.ReactorValues.power_capacity[level]
//            }
//            else {
//                PlayerManager.shared.players[playerID]?.power_current += Structure.ReactorValues.power_provided[level]
//            }
////            print("Local power is: \(power_current)")
//
//        }
//    }
    
//    override func power_handleOverlay() {
////        print("My power is: \(power_current)")
//        if power_lowOverlay.parent == nil && power_current <= Structure.ReactorValues.power_provided[level] {
//            let mySprite = component(ofType: SpriteComponent.self)!.spriteNode
//            mySprite.addChild(power_lowOverlay)
//        }
//        else if power_lowOverlay.parent != nil && power_current > Structure.ReactorValues.power_provided[level] {
//            power_lowOverlay.removeFromParent()
//        }
//    }
    
    // MARK: - Lifetime Functions
    
    func didFinishPlacement() {
        
        for (_, line) in connection_toStructures {
            line.constructPowerLine()
        }
        
        connection_findMasters()
        
        // Deselect our man
        deselect()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.ReactorValues.build_ticks, power: Structure.ReactorValues.power_toBuild))
    }
    
    func didFinishConstruction() {
        connection_setMasterForChildren()
        
        // Update overall energy variables
        PlayerManager.shared.players[playerID]?.power_max += Structure.ReactorValues.power_capacity[level]
        PlayerManager.shared.players[playerID]?.power_current += power_current
    }
    
    func didDied() {
        
        if !isBuilt {
            return
        }
        
        // Make sure the game scene power is updated when a reactor is destroyed
        PlayerManager.shared.players[playerID]?.power_max -= Structure.ReactorValues.power_capacity[level]
        PlayerManager.shared.players[playerID]?.power_current -= power_current
    }
    
    init(playerID: Int) {
        self.playerID = playerID;
        // DO SOMETHING ABOUT THIS PLAYER ID AND TEXTURE. KILL ALL PARAMETERS. PLEASE.
        super.init()
        
        let spriteComponent = Structure2.setupSprite(texture: Structure.Textures.reactor[0],
                                                     size: Structure.Size.large)
        addComponent(spriteComponent)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Reactor"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node,
                                     barWidth: spriteComponent!.spriteNode.size.width * 0.5,
                                     barOffset: spriteComponent!.spriteNode.size.height * 0.61,
                                     health: Structure.ReactorValues.maxHealth[level]))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structure.Textures.reactorLowPower, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        connection_distance = 0
        
        power_current = 0
        
        power_toUse = Structure.ReactorValues.power_toUse
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
