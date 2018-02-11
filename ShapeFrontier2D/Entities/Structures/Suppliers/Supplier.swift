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
    
    func connection_updateMasters(dontLookAt: Supplier) {
        print("Updating masters: ")
        // If the updated master is already in my masters, stop the recursion
        if connection_masters.contains(dontLookAt) {
            return
        }
        
        // Otherwise, add the node to not look at into masters
        connection_masters.append(dontLookAt)
        
        // And loop through all other suppliers, telling them to update themselves with myself
        for structure in connection_toStructures {
            if structure.isSupplier && !structure.isEqual(dontLookAt) {
                connection_updateMasters(dontLookAt: self)
            }
        }
    }
    
    override func connection_findMasters() {
        // if the target structure has no master, make his master this supplier
        for structure in connection_toStructures {
            if !structure.isSupplier && structure.connection_master == nil  {
                structure.connection_master = self
            }
            else if structure.isSupplier {
                // Add myself to their connections, this might cause their list to have lots of me...
                let supplier = structure as! Supplier
                supplier.connection_toStructures.append(self)
                
                // If he is a supplier, check to see if he has a master
                // Make him one of our masters
                if supplier.connection_masters.count > 0 {
                    connection_masters.append(supplier)
                }
            }
        }
        
        // Loop through again if I am a master, tell all the suppliers I am connected to that I am a master
        if connection_masters.count > 1 {
            for structure in connection_toStructures {
                if structure.isSupplier {
                    connection_updateMasters(dontLookAt: self)
                }
            }
        }
    }
    
    override func connection_masterDied() {
        
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
            
            // Add it to the connected structures, add myself to the target structures
            connection_toStructures.append(structure)
            // Add a new powerline to the structure
            connection_powerLine.append(PowerLine(structOne: self, structTwo: structure))
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
