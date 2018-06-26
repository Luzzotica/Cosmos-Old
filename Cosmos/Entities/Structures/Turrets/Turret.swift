//
//  Turret.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Turret : Structure {
    
    func canShoot() -> Bool {
        if isDisabled || !isBuilt {
            return false
        }
        
        power_handleOverlay()
        // If we have no master, stop
        if connection_master == nil {
            return false
        }
        
        // If we don't have enough power in the global power, show that we are out of power
        if PlayerManager.shared.players[playerID]!.power_getCurrent() < power_toUse {
            return false
        }
        
        let ID = Structure.power_prepareFind()
        
        // Find power!
        if power_find(amount: power_toUse, distance: 0, dontLookAtID: ID) != -1 {
            
        }
        
        Structure.power_finishedFind(findID: ID)
        
        return true
    }
    
    override func select() {
        // Create a range indicator for ourselves
        if let weaponComponent = component(ofType: StructureWeaponComponent.self) {
            let indicatorRange = UIHandler.shared.createRangeIndicator(range: weaponComponent.range, color: .red)
            
            // Get the sprite component
            let spriteComponent = component(ofType: SpriteComponent.self)
            spriteComponent!.select(toAdd: [indicatorRange])
        }
    }
    
    override init(texture: SKTexture, size: CGSize, playerID: Int) {
        super.init(texture: texture, size: size, playerID: playerID)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        spriteComponent!.node.name! += "_turret"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
