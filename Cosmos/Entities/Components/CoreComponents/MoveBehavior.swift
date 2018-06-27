//
//  MoveBehavior.swift
//  Cosmos
//
//  Created by Sterling Long on 3/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class MoveBehavior: GKBehavior {

    init(targetSpeed: Float, seek: GKAgent, toAvoid: [GKObstacle]) {
        super.init()
        
        setWeight(100, for: GKGoal(toAvoid: toAvoid, maxPredictionTime: 0.5))
        setWeight(1, for: GKGoal(toSeekAgent: seek))
        setWeight(2, for: GKGoal(toReachTargetSpeed: targetSpeed))
        
        
    }
    
    override init() {
        super.init()
        
        // Make him stop if we have been given no instructions
        setWeight(100.0, for: GKGoal(toReachTargetSpeed: 0.0))
    }
    
    

}
