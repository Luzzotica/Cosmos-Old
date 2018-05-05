//
//  Reactor.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Reactor : Supplier {
    
    var powerProvided : Int = 5
    
    override func tick() {
        super.tick()
        
        if isDisabled || !isBuilt {
            return
        }
        
        if power_current < Structure.ReactorValues.power_capacity
        {
            power_current += powerProvided
            // If the power is greater than his capacity, then we cap it, and add to the game scene what was added
            if power_current > Structure.ReactorValues.power_capacity {
                let powerOver = power_current - Structure.ReactorValues.power_capacity
                gameScene.power_add(toAdd: powerProvided - powerOver)
                power_current = Structure.ReactorValues.power_capacity
            }
            else {
                gameScene.power_add(toAdd: powerProvided)
            }
//            print("Local power is: \(power_current)")
            
        }
    }
    
    override func power_handleOverlay() {
//        print("My power is: \(power_current)")
        if power_lowOverlay.parent == nil && power_current <= powerProvided {
            let mySprite = component(ofType: SpriteComponent.self)!.spriteNode
            mySprite.addChild(power_lowOverlay)
        }
        else if power_lowOverlay.parent != nil && power_current > powerProvided {
            power_lowOverlay.removeFromParent()
        }
    }
    
    // MARK: - Lifetime Functions
    
    override func didFinishPlacement() {
        super.didFinishPlacement()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.ReactorValues.build_ticks, power: Structure.ReactorValues.power_toBuild))
    }
    
    override func didFinishConstruction() {
        super.didFinishConstruction()
        
        // Update overall energy variables
        gameScene.player_powerCapacity += Structure.ReactorValues.power_capacity
        gameScene.player_powerCurrent += power_current
    }
    
    override func didDied() {
        super.didDied()
        
        if !isBuilt {
            return
        }
        // Make sure the game scene power is updated when a reactor is destroyed
        gameScene.player_powerCapacity -= Structure.ReactorValues.power_capacity
        gameScene.player_powerCurrent -= power_current
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: Structure.Size.large, team: team)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Reactor"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node,
                                     barWidth: spriteComponent!.spriteNode.size.width * 0.5,
                                     barOffset: spriteComponent!.spriteNode.size.height * 0.61,
                                     health: Structure.ReactorValues.maxHealth))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_reactor"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.reactorLowPower, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        connection_distance = 0
        
        power_current = 0
        
        power_toUse = Structure.ReactorValues.power_toUse
        powerProvided = Structure.ReactorValues.power_provided
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
