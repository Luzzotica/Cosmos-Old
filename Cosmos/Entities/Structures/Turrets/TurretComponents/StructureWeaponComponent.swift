//
//  StructureWeaponComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 4/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class StructureWeaponComponent : GenericWeaponComponent {
    
    func structureHasPower() -> Bool {
        // Cast our entity to a turret
        if let structure = entity as? Turret {
            // Make sure it has power
            return structure.canShoot()
        }
        else {
            return false
        }
    }
}
