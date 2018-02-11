//
//  Supplier.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Supplier : Structure {
    
    var connection_toStructures : [Structure] = []
    var connection_masters : [Supplier] = []
    
    func drawPower(amount: Int) {
        
    }
    
    override func alreadyConnected(toCheck: Structure) -> Bool {
        // First, check if he is not a supplier, and that his master is nil
        if !toCheck.isSupplier && toCheck.connection_master != nil {
            return true
        }
        
        // Next, checks if we are already connected to the target structure
        // Can probably add a check here for the number of connected structures later
        for structure in connection_toStructures {
            if toCheck.isEqual(structure) {
                return true
            }
        }
        return false
    }
    
    override func connection_addTo(structure: Structure) {
        // If the target structure isn't already connected to us, we do cool things
        if !alreadyConnected(toCheck: structure) {
            
            // Add it to the connected structures
            connection_toStructures.append(structure)
            // Add a new powerline to the structure
            connection_powerLine.append(PowerLine(structOne: self, structTwo: structure))
            
            // if the target structure has no master, make his master this supplier
            if structure.connection_master == nil {
                structure.connection_master = self
            }
        }
    }
    
    override func connection_updateLines() {
        for i in stride(from: connection_powerLine.count - 1, through: 0, by: -1) {
            if connection_powerLine[i].toDestroy {
                connection_powerLine.remove(at: i)
            }
            else {
                connection_powerLine[i].update()
            }
        }
    }
    
    func connection_remove(toRemove: Structure) -> Bool {
        for i in 0..<connection_toStructures.count {
            if connection_toStructures[i].isEqual(toRemove) {
                connection_toStructures.remove(at: i)
                return true
            }
        }
        return false
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        isSupplier = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
