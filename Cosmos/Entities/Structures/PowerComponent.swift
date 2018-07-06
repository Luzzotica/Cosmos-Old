//
//  PowerComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 7/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class PowerComponent: GKComponent
{
    // Recursive searching variables
    static var dontLookAtID = 0
    static let dontLookAtID_max = 10000
    static var dontLookAt : [Int:[Supplier]] = [:]
    
    // Connection variables
    var connection_master : Supplier?
    var connection_powerLine : PowerLine?
    
    // MARK: - POWERRRR FUNCTIONS
    
    static func power_prepareFind() -> Int
    {
        // Prepares the static variables for a new find, returns the dontLookAtID after prep
        // Get a new dontLookAtID by increasing it by one
        dontLookAtID += 1
        
        // If the dontLookAtID is greater than one, we restart at 0
        if dontLookAtID > dontLookAtID_max
        {
            dontLookAtID = 0
        }
        
        // Prepare the dontLookAt dictionary for that ID usage
        dontLookAt[dontLookAtID] = []
        
        return dontLookAtID
    }
    
    static func power_finishedFind(findID: Int)
    {
        dontLookAt[findID] = []
    }
    
    // Traces to a power source with power
    func power_find(amount: Int, distance: Int, dontLookAtID: Int) -> Int
    {
        // If our master is not built, we want to stop
        if !connection_master!.isBuilt
        {
            return -1
        }
        
        // If we have energy globaly, use it
        if PlayerManager.shared.players[playerID]!.power_current >= amount
        {
            let distance = connection_master!.power_find(amount: amount, distance: distance + 1, dontLookAtID: dontLookAtID)
            
            // If the distance wasn't negative 1, then we light up our powerline to out master!
            if distance != -1
            {
                connection_powerLine?.powerUp()
            }
            return distance
        }
            // If we have no energy, overlay the out of power
        else
        {
            return -1
        }
        
    }
    
    func power_handleOverlay()
    {
        
        // Adds the out of power overlay if we
        // Have no master or If we are out of power
        if isDisabled || !isBuilt ||
            (power_lowOverlay.parent == nil
                && (connection_master == nil
                    || PlayerManager.shared.players[playerID]!.power_current < power_toUse)),
            let spriteComponent = component(ofType: SpriteComponent.self)
        {
            if power_lowOverlay.parent == nil
            {
                spriteComponent.spriteNode.addChild(power_lowOverlay)
            }
        }
            // Removes the power overlay if
            // We have a master, and we have power
            // Demorgans law for the win in negating the previous if statement =D
        else if power_lowOverlay.parent != nil
            && connection_master != nil
            && PlayerManager.shared.players[playerID]!.power_current >= power_toUse
        {
            power_lowOverlay.removeFromParent()
        }
    }
    
    // MARK: - Connection Functions
    
    func connection_findMasters() {
        //        print("Finding wrong master")
    }
    
    func connection_masterDied() {
        //        print("got here")
        connection_master = nil
        connection_powerLine = nil
    }
    
    func alreadyConnected(toCheck: Structure) -> Bool {
        if connection_master == nil {
            return false
        }
        if toCheck.isEqual(connection_master!) {
            return true
        }
        return false
    }
    
    func connection_addTo(structure: Structure) {
        // For non supplier structures...
        // If the passed structure is not equal to current master, update it. The construction manager only passes the closest structure
        if connection_master != structure {
            
            // Connect to the new supplier
            connection_master = (structure as! Supplier)
            
            // If we have a connection already, destroy it.
            if connection_powerLine != nil {
                connection_powerLine?.destroySelf()
                connection_powerLine = nil
            }
            
            // Create the new power line
            connection_powerLine = PowerLine(structOne: self, structTwo: structure)
        }
    }
    
    func connection_updateLines() {
        // If our master/powerline isn't nil
        if connection_powerLine != nil {
            // We check if the powerline wants to be destroyed
            if connection_powerLine!.toDestroy {
                connection_powerLine = nil
            }
                // Otherwise we update it. This checks if the range is too long
            else {
                connection_powerLine?.update()
            }
        }
    }
}
