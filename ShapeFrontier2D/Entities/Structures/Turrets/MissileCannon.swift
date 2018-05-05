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
    
    override func didFinishPlacement() {
        super.didFinishPlacement()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.MissileCannonValues.build_ticks, power: Structure.MissileCannonValues.power_toBuild))
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: Structure.Size.large, team: team)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Missile Cannon"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node, barWidth: spriteComponent!.spriteNode.size.width * 0.5, barOffset: spriteComponent!.spriteNode.size.height * 0.61, health: Structure.MissileCannonValues.maxHealth))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_missileCannon"
        
        let weapon = MissileCannonComponent(range: Structure.MissileCannonValues.range, damage: Structure.MissileCannonValues.damage, damageRate: Structure.MissileCannonValues.damageRate, player: 1, targetPlayers: [666])
        weapon.setPossibleTargets(types: .ship)
        
        addComponent(weapon)
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structures.outOfPowerOverlay, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        power_toUse = Structure.PulseCannonValues.power_toUse
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
