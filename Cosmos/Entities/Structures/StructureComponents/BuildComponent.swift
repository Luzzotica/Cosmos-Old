//
//  BuildComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 5/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class BuildComponent: GKComponent {
    
    let build_ticksToBuild : Int
    let build_power : Int
    
    // Tick counter
    var build_ticksCurrent : Int = 0
    var build_finished = false
    
    var currentTime : TimeInterval = 0
    
    init(ticks: Int, power: Int) {
        build_ticksToBuild = ticks
        build_power = power
        
        super.init()
    }
    
    override func didAddToEntity() {
        // Get the health component of the structure
        guard let healthComponent = entity?.component(ofType: HealthComponent.self) else {
            return
        }
        
        // Set him to 10% life
        healthComponent.setHealth(healthComponent.health_max * 0.1)
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
            if structure.power_find(amount: build_power, distance: 0, dontLookAtID: Structure.dontLookAtID) != -1 {
                guard let healthComponent = structure.component(ofType: HealthComponent.self) else {
//                    print("No health component!")
                    return
                }
                
                // Build the structure based on ticks to build and his max health
                let healAmount = healthComponent.health_max / CGFloat(build_ticksToBuild)
                healthComponent.heal(healAmount)
                
                // Build our structure!
                build_ticksCurrent += 1
                
                // If current ticks is greater than or equal to ticks needs
                if build_ticksCurrent >= build_ticksToBuild {
                    // Then we are all done building, ACTIVATE
                    structure.isBuilt = true
                    
                    // On finish, call didFinishConstruction
                    structure.didFinishConstruction()
                    
                    // Remove ourselves from the structures components
                    structure.removeComponent(ofType: BuildComponent.self)
                    EntityManager.shared.removeComponent(component: self)
                }
            }
            else {
//                print("No power found")
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
