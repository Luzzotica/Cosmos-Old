//
//  PlayerEntity.swift
//  Cosmos
//
//  Created by Sterling Long on 3/30/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerEntity : GKEntity {
    // MARK: - Properties
    
    var playerID : Int
    var playerHUD : PlayerHUD?
    
    var teamEntity : TeamEntity?
    
    // Player Power
    var power_max : Int = 100 {
        didSet {
            print("Set max power")
            // Do cool things!
        }
    }
    
    var power_current : Int = 100 {
        didSet {
            print("Set current power")
            if power_current > power_max {
                power_current = power_max
            }
        }
    }
    
    // Player Minerals
    var minerals : Int = 10000
    
    var enemies : [Int] = []
    
    init(player: Int, playerHUD: PlayerHUD? = nil) {
        self.playerHUD = playerHUD
        self.playerID = player
        
        super.init()
        
        // Set the playerHUD, if there was one, to have self as a player
        self.playerHUD?.playerEntity = self
        
    }
    
    // MARK: - Power
    
    func power_getCurrent() -> Int {
        return power_current
    }
    
    func power_getMax() -> Int {
        return power_max
    }
    
    func power_use(amount: Int, deficit: Int) {
        // Subtract energy from global power
        power_current -= amount
        
        // If there was a deficit, we find other reactors
        if deficit != -1 {
            // Store the deficit
            var deficit_curr = deficit
            
            // While it's greater than 0, we want to keep looking for reactors with energy
            while deficit_curr > 0 {
                
                let reactor = power_findPowerSourceWithPower()
                
                if reactor != nil {
                    reactor!.power_current -= deficit_curr
                    // Set the deficit to whatever the reactors power now is
                    deficit_curr = reactor!.power_current
                    
                    // If the deficit is still less than 0, then we want to set the reactors power to 0
                    // Continue with the while loop
                    if deficit_curr < 0 {
                        reactor!.power_current = 0
                        deficit_curr *= -1
                    }
                }
                else {
                    print("This was impossible. Do something about it. Now.")
                    deficit_curr = 0
                }
            }
        }
    }
    
    func power_findPowerSourceWithPower() -> Supplier? {
//        for reactor in player_suppliers {
//            if reactor.power_current > 0 {
//                return reactor
//            }
//        }
        
        return nil
    }
    
    // MARK: - Minerals
    
    func getCurrentMinerals() -> Int {
        return minerals
    }
    
    func minerals_spend(amount: Int) {
        minerals -= amount
    }
    
    // MARK: - Team Functions
    
    func addToTeam(team: TeamEntity) {
        teamEntity = team
    }
    
    // MARK: - Player UI
    
    func enemyDied(_ enemy: GKEntity) {
        playerHUD!.enemyDied(enemy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
