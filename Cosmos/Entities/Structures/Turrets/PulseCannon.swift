//
//  PulseCannon.swift
//  Cosmos
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PulseCannon : Turret {
    
    // MARK: - Upgrade Functions
    
    override func upgrade_start() {
        super.upgrade_start()
        
        let upgradeComponent = UpgradeComponent(ticks: Structure.PulseCannonValues.upgrade_ticks[level],
                                                power: Structure.PulseCannonValues.power_toUpgrade)
        
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
            healthComponent.setMaxHealth(Structure.PulseCannonValues.maxHealth[level])
        }
        
        // Change his sprite
        if let spriteComponent = component(ofType: SpriteComponent.self) {
            spriteComponent.setSpriteTexture(texture: Structure.Textures.pulseLaser[level])
        }
        
        // Change his damage
        if let weaponComponent = component(ofType: PulseCannonComponent.self) {
            weaponComponent.setDamage(damage: Structure.PulseCannonValues.damage[level])
            weaponComponent.setDamage(damage: Structure.PulseCannonValues.damageRate[level])
            weaponComponent.setDamage(damage: Structure.PulseCannonValues.range[level])
        }
    }
    
    override func upgrade_isMaxLevel() -> Bool {
        return level >= Structure.PulseCannonValues.level_max
    }
    
    override func didFinishPlacement() {
        super.didFinishPlacement()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.PulseCannonValues.build_ticks, power: Structure.PulseCannonValues.power_toBuild))
    }
    
    init(playerID: Int) {
        super.init(texture: Structure.Textures.pulseLaser[0], size: Structure.Size.large, playerID: playerID)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Pulse Laser"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node, barWidth: spriteComponent!.spriteNode.size.width * 0.5, barOffset: spriteComponent!.spriteNode.size.height * 0.61, health: Structure.PulseCannonValues.maxHealth[level]))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_pulseLaser"
        
        let weapon = PulseCannonComponent(range: Structure.PulseCannonValues.range[level],
                                          damage: Structure.PulseCannonValues.damage[level],
                                          damageRate: Structure.PulseCannonValues.damageRate[level],
                                          player: 1, targetPlayers: [666])
        weapon.setPossibleTargets(types: .ship)
        
        addComponent(weapon)
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structure.Textures.outOfPowerOverlay, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        power_toUse = Structure.MissileCannonValues.power_toUse
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
