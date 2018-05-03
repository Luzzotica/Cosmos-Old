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
        if isDisabled {
            return
        }
        
        if power_current < power_capacity
        {
            power_current += powerProvided
            // If the power is greater than his capacity, then we cap it, and add to the game scene what was added
            if power_current > power_capacity {
                let powerOver = power_current - power_capacity
                gameScene.power_add(toAdd: powerProvided - powerOver)
                power_current = power_capacity
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
    
    override func build() {
        super.build()
//        if !isBuilding {
//            let normalTexture = SKTexture(image: #imageLiteral(resourceName: "ReactorStage1"))
//        }
    }
    
    override func didDied() {
        super.didDied()
        
        // Make sure the game scene power is updated when a reactor is destroyed
        gameScene.player_powerCapacity -= power_capacity
        gameScene.player_powerCurrent -= power_current
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 10
        health_current = health_max

        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 2
        power_toUse = 0
        
        power_capacity = 100
        power_current = 100
    }
    
    override func didFinishConstruction() {
        super.didFinishConstruction()
        //Update overall energy variables
        gameScene.player_powerCapacity += power_capacity
        gameScene.player_powerCurrent += power_current
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: StructureSize.large, team: team)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(mySprite!.size.width * 0.5), name: "Reactor"))
        addComponent(HealthComponent(parentNode: myNode, barWidth: mySprite!.size.width * 0.5, barOffset: mySprite!.size.height * 0.61, health: 50))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        myNode.name! += "_reactor"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.reactorLowPower, size: mySprite.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
        
        connection_distance = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
