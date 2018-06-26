//
//  TeamEntity.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 6/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class TeamEntity: GKEntity {
    
    // Team ID
    var teamID : Int
    
    // Players on this team
    var playersOnTeam : [PlayerEntity] = []
    
    // Team Power
    var power_max : Int = 0
    var power_current : Int = 0
    
    // Team Minerals
    var minerals : Int = 10000
    
    // MARK: - Players
    
    func player_add(player: PlayerEntity) {
        playersOnTeam.append(player)
        
        // Tell the player they were added to a team
        player.addToTeam(team: self)
    }
    
    // MARK: - Minerals
    
    func minerals_mined(_ amount: Int) {
        minerals += amount
    }
    
    func minerals_hasEnough(_ amount: Int) -> Bool {
        if minerals >= amount {
            minerals_spend(amount)
            return true
        }
        else {
            return false
        }
    }
    
    func minerals_spend(_ amount: Int) {
        minerals -= amount
    }
    
    // MARK: - Power
    
    func getPower() -> Int {
        return power_current
    }
    
    func power_use(_ amount: Int) {
        self.power_current -= amount
    }
    
    func power_addToCurrent(_ amount: Int) {
        self.power_current += amount
    }
    
    func power_addToMax(_ amount: Int) {
        power_max += amount
    }
    
    init(ID: Int) {
        self.teamID = ID
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
