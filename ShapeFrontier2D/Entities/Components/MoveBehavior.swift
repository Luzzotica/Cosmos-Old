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
    
    var goal_seekTarget : GKGoal?
    var goal_circleTarget : GKGoal?
    var goal_speed : GKGoal?
    var goal_avoid : GKGoal?

    init(targetSpeed: Float, seek: [GKAgent], avoid: [GKAgent]) {
        super.init()
        
        goal_seekTarget = GKGoal(toCohereWith: seek, maxDistance: Float(sceneWidth), maxAngle: .pi/2.0)
        goal_circleTarget = GKGoal(toSeparateFrom: seek, maxDistance: Float(sceneWidth * 0.08), maxAngle: .pi/16.0)
        goal_speed = GKGoal(toReachTargetSpeed: targetSpeed)
        goal_avoid = GKGoal(toAvoid: avoid, maxPredictionTime: 1.0)
        
        setWeight(60, for: goal_seekTarget!)
        setWeight(50, for: goal_circleTarget!)
//        setWeight(1000, for: GKGoal(toWander: 500000.0))
//        setWeight(55, for: goal_speed!)
//        setWeight(1.0, for: goal_avoid!)
        
    }
    
    init(targetSpeed: Float, seek: GKAgent) {
        
    }

}
