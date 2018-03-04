//
//  MoveBehavior.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

// 1
class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        // 2
        if targetSpeed > 0 {
            // 3
            setWeight(0.1, for: GKGoal(toReachTargetSpeed: targetSpeed))
            // 4
            setWeight(0.5, for: GKGoal(toSeekAgent: seek))
            // 5
            setWeight(1.0, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
        }
    }
}
