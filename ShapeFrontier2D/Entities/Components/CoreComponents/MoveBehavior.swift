//
//  MonsterBehavior.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
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
