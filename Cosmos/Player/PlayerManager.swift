//
//  PlayerManager.swift
//  Cosmos
//
//  Created by Sterling Long on 6/21/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerManager: NSObject {
    
    static let shared = PlayerManager()
    
    var clientPlayer : PlayerEntity!
    
    var players : [Int:PlayerEntity] = [:]
    
    var currentID : Int = 1
    
    func createClientPlayer() -> PlayerEntity {
        // Create a new player entity
        let newPlayer = PlayerEntity(player: currentID, playerHUD: PlayerHUD.shared)
        
        // Add the player to our player dictionary
        players[currentID] = newPlayer
        
        // Increment the ID
        currentID += 1
        
        // This is our main player! Set him up!
        clientPlayer = newPlayer
        
        return newPlayer
    }
    
    func addOtherPlayer() -> PlayerEntity {
        // Create a new player entity
        let newPlayer = PlayerEntity(player: currentID)
        
        // Add the player to our player dictionary
        players[currentID] = newPlayer
        
        // Increment the ID
        currentID += 1
        
        return newPlayer
    }
    
}



