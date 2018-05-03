//
//  PulseLaser.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PulseLaser : Turret {
    
    
    override func build() {
        super.build()
        
        if !underConstruction {
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 8
        health_current = health_max
        
        // Reactor power priority is low, doesn't need power...
        power_priority = 0
        power_toBuild = 1
        power_toUse = 1
        
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: StructureSize.large, team: team)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(mySprite!.size.width * 0.5), name: "Pulse Laser"))
        addComponent(HealthComponent(parentNode: myNode, barWidth: mySprite!.size.width * 0.5, barOffset: mySprite!.size.height * 0.61, health: 50))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        range = sceneWidth * 0.5
        
        myNode.name! += "_pulseLaser"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: mySprite.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
        
        let weapon = LaserTurret(range: range, damage: 5.0, damageRate: 0.5, player: 1, targetPlayers: [666])
        weapon.setPossibleTargets(types: .ship)
        
        addComponent(weapon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
