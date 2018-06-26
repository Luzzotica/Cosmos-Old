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
    
    var connection_toStructures : [(Structure, PowerLine)] = []
    var connection_masters : [(Supplier, Int)] = []
    var connection_distance: Int = -1
    
    func power_use(amount: Int) {
        power_current -= amount
        
        var deficit = -1
        if power_current < 0 {
            deficit = abs(power_current)
            power_current = 0
        }
        
        PlayerManager.shared.players[playerID]!.power_use(amount: amount, deficit: deficit)
    }
    
    // Traces to a power source with power
    override func power_find(amount: Int, distance: Int, dontLookAtID: Int) -> Int {
        
        // Base case: If our current power is greater than 0, we've arrived
        if power_current > 0 {
            
            // Subtract the power from the source
            power_use(amount: amount)
            
            // Return the distance traveled to power
            return distance
        }
        
        // If not the base case, loop through all masters
        // This (should) be sorted, lowest distance on left
        for master in connection_masters {
            
//            print(Structure.dontLookAt[dontLookAtID]?.count)
            // If the master we are looking at is in our don't look index, skip him
            if let _ = Structure.dontLookAt[dontLookAtID]?.index(of: master.0) {
                continue
            }
            
            // Add himself to the don't look at list
            Structure.dontLookAt[dontLookAtID]!.append(self)
            
            // Get the distance found since we weren't at the base case
            let distanceFound = master.0.power_find(amount: amount, distance: distance + 1, dontLookAtID: dontLookAtID)
            
            // If the distance found isn't -1, then we light it up!
            if distanceFound != -1 {
                // Find the structure's powerline and light it up!
                for (structure, powerline) in connection_toStructures {
                    if structure == master.0 {
                        powerline.powerUp()
                    }
                }
                
                // return the distance found
                return distanceFound
            }
            else {
//                print("Nodes master is: \(master.0.name)")
            }
            // Need to add consistency check between distanceFound and expected
        }
//        print("Node has no masters")
        return -1
    }
    
    // MARK: - Connection Functions
    
    func connection_containsMaster(supplier: Supplier) -> Bool {
        // Loop through and check the supplier in the tuple
        for i in 0..<connection_masters.count {
            if connection_masters[i].0.isEqual(supplier) {
                print("We already have that master")
                return true
            }
        }
        
        // If it wasn't in the list, we return false
        return false
    }
    
    func connection_updateMasters(dontLookAt: Supplier, distance: Int) {
        //print("Updating masters for: \(mySprite.name!)")
        
        // If the updated master is already in my masters, stop the recursion
        if connection_containsMaster(supplier: dontLookAt) {
            return
        }
        
        // Otherwise, add the node to not look at into masters
        connection_masters.append((dontLookAt, distance))
        connection_masters.sort(by: {$0.1 < $1.1})
//        var listOfDistances = "List of distances:"
//        for master in connection_masters {
//            listOfDistances.append(" \(master.1)")
//        }
//        print(listOfDistances)
        
        //if distance passed is less than current distance, update it
        if (distance < connection_distance || connection_distance == -1)
        {
            //print("Updating Distance: \(distance) for \(mySprite.name!)")
            connection_distance = distance
        }
        
        // If I'm fully built
        if isBuilt {
            // Loop through all other suppliers, telling them to update themselves with myself
            for structure in connection_toStructures {
                if structure.0.isSupplier && !structure.0.isEqual(dontLookAt) {
                    let supplier = structure.0 as! Supplier
                    supplier.connection_updateMasters(dontLookAt: self, distance: distance + 1)
                }
            }
        }
    }
    
    override func connection_findMasters() {
        // Loop through all the people we are connected to
        for structure in connection_toStructures {
            // If the target structure is NOT a supplier and has no master, make his master ourself
            if !structure.0.isSupplier && structure.0.connection_master == nil  {
                structure.0.connection_master = self
                structure.0.connection_powerLine = structure.1
            }
                // If they are a supplier, do different things!
            else if structure.0.isSupplier {
                // Add myself to their connections, this might cause their list to have lots of me...
                let supplier = structure.0 as! Supplier
                supplier.connection_toStructures.append((self, structure.1))
                
                // If he is not built, he can't be out master so we want to stop
                if !supplier.isBuilt {
                    continue
                }
                
                // If he is a supplier, check to see if he is a master or a reactor
                // Make him one of our masters
                if supplier.connection_masters.count > 0 || supplier is Reactor {
                    if supplier.connection_distance < connection_distance || connection_distance == -1 {
                        connection_distance = supplier.connection_distance + 1
                    }
                    //                    print("Distance to Power Supply: \(connection_distance)")
                    connection_masters.append((supplier, supplier.connection_distance))
                }
            }
        }
        
        // Sort the masters based on distance
        connection_masters.sort(by: {$0.1 < $1.1})
    }
    
    func connection_setMasterForChildren() {
        // Loop through if I am a master, tell all the suppliers I am connected to that I am a master
        if connection_masters.count > 1 || self is Reactor {
            for structure in connection_toStructures {
                //                print("connected to: \(structure.0.component(ofType: SpriteComponent.self)!.node.name!)")
                if structure.0.isSupplier {
                    let supplier = structure.0 as! Supplier
                    supplier.connection_updateMasters(dontLookAt: self, distance: connection_distance + 1)
                }
            }
        }
            // If we have at least one connection, tell everyone but our master that we are a master
        else if connection_masters.count == 1 {
            for structure in connection_toStructures {
                // If the structure is a supplier and our master, we skip over him.
                // Don't tell him NUFFING!
                if structure.0.isSupplier {
                    if connection_containsMaster(supplier: structure.0 as! Supplier) {
                        continue
                    }
                }
                
                // Tell everone else we are connected to about all the great things we are doing with life.
                //                print("connected to: \(structure.0.component(ofType: SpriteComponent.self)!.node.name!)")
                if structure.0.isSupplier {
                    let supplier = structure.0 as! Supplier
                    supplier.connection_updateMasters(dontLookAt: self, distance: connection_distance + 1)
                }
            }
        }
    }
    
    func connection_masterLost(master: Supplier) {
        // Remove the guy who told us from our list
        connection_masterDied(master: master)
        
        //if we aren't a master, we tell our children we aren't a master too
        if connection_masters.count <= 1 && !(self is Reactor)
        {
//            print("No longer a master")
            
            for master_current in connection_masters
            {
                master_current.0.connection_masterLost(master: self)
            }
        }
    }
    
    func connection_masterDied(master: Supplier) {
        if connection_masters.count > 0 {
            for index in 0...connection_masters.count - 1
            {
                if connection_masters[index].0 == master
                {
                    //We found the guy that died, remove him
                    connection_masters.remove(at: index)
                    break
                }
            }
        }
    }
    
    override func alreadyConnected(toCheck: Structure) -> Bool {
        // First, check if he is not a supplier, and that his master is nil
        if !toCheck.isSupplier && toCheck.connection_master != nil {
            return true
        }
        
        // Next, checks if we are already connected to the target structure
        // Can probably add a check here for the number of connected structures later
        for (structure, _) in connection_toStructures {
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
            // Attach to it a powerline. Tuple makes it nice for accessing powerlines later
            connection_toStructures.append((structure, PowerLine(structOne: self, structTwo: structure)))
            
            // Add a new powerline to the structure
//            connection_powerLine.append(PowerLine(structOne: self, structTwo: structure))
        }
    }
    
    // This function is called during creation
    override func connection_updateLines() {
        for i in stride(from: connection_toStructures.count - 1, through: 0, by: -1) {
            if connection_toStructures[i].1.toDestroy {
                connection_toStructures.remove(at: i)
            }
            else {
                connection_toStructures[i].1.update()
            }
        }
    }
    
    // This function is called by the powerline
    func connection_remove(toRemove: Structure) -> Bool {
        for i in 0..<connection_toStructures.count {
            if connection_toStructures[i].0.isEqual(toRemove) {
                
                connection_toStructures.remove(at: i)
                return true
            }
        }
        return false
    }
    
    // MARK: - Lifetime Functions
    
    override func didFinishPlacement() {
        for (_, line) in connection_toStructures {
            line.constructPowerLine()
        }
        
        connection_findMasters()
        
        // Deselect our man
        deselect()
    }
    
    override func didFinishConstruction() {
        super.didFinishConstruction()
        
        connection_setMasterForChildren()
    }
    
    override func didDied() {
        super.didDied()
        //Break all connections with everybody, turrets will lose masters
//        print(connection_toStructures.count)
        for i in stride(from: connection_toStructures.count - 1, through: 0, by: -1)
        {
            connection_toStructures[i].1.destroySelf()
        }
        
        // If we were a master
        if connection_masters.count > 1 || self is Reactor
        {
            //Tell all masters that I died
            for master in connection_masters
            {
                master.0.connection_masterDied(master: self)
            }
            
            // Make them check themselves if they are still masters
            for master in connection_masters
            {
                master.0.connection_masterLost(master: self)
            }
        }
        
        connection_masters.removeAll()
    }
    
    override init(texture: SKTexture, size: CGSize, playerID: Int) {
        super.init(texture: texture, size: size, playerID: playerID)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        isSupplier = true
        
        spriteComponent!.node.name! += "_supplier"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
