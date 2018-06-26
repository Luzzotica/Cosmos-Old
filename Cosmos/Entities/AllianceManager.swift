//
//  AllianceManager.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/14/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation

class AllianceManager {
    
    static let shared = AllianceManager()
    
    func getPlayerEnemies(player: Int) -> [Int] {
        if player == 1 {
            return [666]
        }
        else if player == 666 {
            return [1]
        }
        else {
            return [1]
        }
    }
    
}
