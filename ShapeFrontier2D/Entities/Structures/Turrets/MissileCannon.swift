//
//  Missile Cannon.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit


class MissileCannon : Turret {
    
    override func build() {
        super.build()
        
        if !underConstruction {
            
        }
    }
    
    override func setupStructure() {
        super.setupStructure()
        power_toUse = 4
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: StructureSize.large, team: team)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Missile Cannon"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node, barWidth: spriteComponent!.spriteNode.size.width * 0.5, barOffset: spriteComponent!.spriteNode.size.height * 0.61, health: MissileCannonValues.maxHealth))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_missileCannon"
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        setupStructure()
        
        let weapon = MissileCannonComponent(range: MissileCannonValues.range, damage: MissileCannonValues.damage, damageRate: MissileCannonValues.damageRate, player: 1, targetPlayers: [666])
        weapon.setPossibleTargets(types: .ship)
        
        addComponent(weapon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
