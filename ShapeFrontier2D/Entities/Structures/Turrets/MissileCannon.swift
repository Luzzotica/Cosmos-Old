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
    
    // MARK: - Upgrade Functions
    
    override func upgrade_start() {
        super.upgrade_start()
        
        let upgradeComponent = UpgradeComponent(ticks: Structure.MissileCannonValues.upgrade_ticks[level],
                                                power: Structure.MissileCannonValues.power_toUpgrade)
        
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
            healthComponent.setMaxHealth(Structure.MissileCannonValues.maxHealth[level])
        }
        
        // Change his sprite
        if let spriteComponent = component(ofType: SpriteComponent.self) {
            spriteComponent.setSpriteTexture(texture: Structure.Textures.missileCannon[level])
        }
        
        // Change his damage
        if let weaponComponent = component(ofType: MissileCannonComponent.self) {
            weaponComponent.setDamage(damage: Structure.MissileCannonValues.damage[level])
            weaponComponent.setDamage(damage: Structure.MissileCannonValues.damageRate[level])
            weaponComponent.setDamage(damage: Structure.MissileCannonValues.range[level])
        }
    }
    
    override func upgrade_isMaxLevel() -> Bool {
        return level >= Structure.MissileCannonValues.level_max
    }
    
    override func didFinishPlacement() {
        super.didFinishPlacement()
        
        // Add a build component!
        addComponent(BuildComponent(ticks: Structure.MissileCannonValues.build_ticks, power: Structure.MissileCannonValues.power_toBuild))
    }
    
    init(texture: SKTexture, team: Team) {
        super.init(texture: texture, size: Structure.Size.large, team: team)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent!.spriteNode.size.width * 0.5), name: "Missile Cannon"))
        addComponent(HealthComponent(parentNode: spriteComponent!.node, barWidth: spriteComponent!.spriteNode.size.width * 0.5, barOffset: spriteComponent!.spriteNode.size.height * 0.61, health: Structure.MissileCannonValues.maxHealth[level]))
        addComponent(TeamComponent(team: team))
        addComponent(PlayerComponent(player: 1))
        addComponent(EntityTypeComponent(type: Type.structure))
        
        spriteComponent!.node.name! += "_missileCannon"
        
        let weapon = MissileCannonComponent(range: Structure.MissileCannonValues.range[level],
                                            damage: Structure.MissileCannonValues.damage[level],
                                            damageRate: Structure.MissileCannonValues.damageRate[level],
                                            player: 1, targetPlayers: [666])
        weapon.setPossibleTargets(types: .ship)
        
        addComponent(weapon)
        
        // Set up low power overlay
        power_lowOverlay = SKSpriteNode(texture: Structure.Textures.outOfPowerOverlay, size: spriteComponent!.spriteNode.size)
        power_lowOverlay.zPosition = 1
        
        power_toUse = Structure.PulseCannonValues.power_toUse
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
