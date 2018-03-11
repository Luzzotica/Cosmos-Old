//
//  GameScene_Power.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func power_add(toAdd: Int)
    {
        player_powerCurrent += toAdd
        //        print("Current power is \(power_current)")
        if player_powerCurrent > player_powerCapacity
        {
            player_powerCurrent = player_powerCapacity
        }
    }
    
    func power_use(amount: Int, deficit: Int) {
        // Subtract energy from global power
        player_powerCurrent -= amount
        //        print("Current power is \(power_current)")
        
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
        for reactor in player_suppliers {
            if reactor.power_current > 0 {
                return reactor
            }
        }
        
        return nil
    }
    
}
