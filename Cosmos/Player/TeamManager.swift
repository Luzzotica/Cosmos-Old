//
//  File.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 6/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class TeamManager: NSObject {
    
    static let shared = TeamManager()
    
    var teams : [Int:TeamEntity] = [:]
    
    var currentID = 1
    
    func createNewTeam() -> TeamEntity {
        // Create a new team
        let newTeam = TeamEntity(ID: currentID)
        
        // Increment the ID
        currentID += 1
        
        // Return the new team
        return newTeam
    }

}
