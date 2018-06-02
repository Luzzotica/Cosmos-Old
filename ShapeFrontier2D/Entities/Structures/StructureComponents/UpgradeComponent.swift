//
//  BuildComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 6/2/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class UpgradeComponent: GKComponent {
    
    let upgrade_ticksToBuild : Int
    let upgrade_power : Int
    
    // Tick counter
    var upgrade_ticksCurrent : Int = 0
    var upgrade_finished = false
    
    var currentTime : TimeInterval = 0
    
    init(ticks: Int, power: Int) {
        upgrade_ticksToBuild = ticks
        upgrade_power = power
        
        super.init()
    }
    
    override func didAddToEntity() {
        // Disable the structure
        if let structure = entity as? Structure {
            structure.isDisabled = true
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // Call the super update
        super.update(deltaTime: seconds)
        
        // Keep track of time passed
        // If its been our tick time, we update!
        currentTime += seconds
        if currentTime < GameValues.TickTime {
            return
        }
        
        // Find power!
        if let structure = entity as? Structure {
            // If we have no master, stop
            // If we are a supplier, we check our list of masters
            if structure is Supplier {
                let supplier = structure as? Supplier
                //                print("Master Count:", supplier!.connection_masters.count)
                if supplier!.connection_masters.count == 0 {
                    return
                }
            }
                // If we are a normal structure, we just check the single connection_master
            else {
                if structure.connection_master == nil {
                    return
                }
            }
            
            let ID = Structure.power_prepareFind()
            
            // Find power!
            if structure.power_find(amount: upgrade_power, distance: 0, dontLookAtID: Structure.dontLookAtID) != -1 {
                
                // Build our structure!
                upgrade_ticksCurrent += 1
                
                // If current ticks is greater than or equal to ticks needs
                if upgrade_ticksCurrent >= upgrade_ticksToBuild {
                    // Active him once it's done!
                    structure.isDisabled = false
                    
                    // Run the finish upgrade!
                    structure.upgrade_finish()
                    
                    // Remove ourselves from the structures components
                    structure.removeComponent(ofType: UpgradeComponent.self)
                    EntityManager.shared.removeComponent(component: self)
                }
            }
            else {
                return
            }
            
            Structure.power_finishedFind(findID: ID)
        }
        
        // Reset our time if we got to this point
        currentTime = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
