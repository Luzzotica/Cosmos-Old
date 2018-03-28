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

    init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        
        goal_seekTarget = GKGoal(toSeekAgent: seek)
        goal_speed = GKGoal(toReachTargetSpeed: targetSpeed)
        goal_avoid = GKGoal(toAvoid: avoid, maxPredictionTime: 2.0)
        
        setWeight(60, for: goal_seekTarget!)
        setWeight(50, for: goal_speed!)
        setWeight(50, for: goal_avoid!)
        
        //        goal_seekTarget = GKGoal(toCohereWith: seek, maxDistance: Float(sceneWidth), maxAngle: .pi/2.0)
        //        goal_circleTarget = GKGoal(toSeparateFrom: seek, maxDistance: Float(sceneWidth * 0.08), maxAngle: .pi/16.0)
        
    }
    
    override init() {
        super.init()
        
        // Make him stop if we have been given no instructions
        goal_speed = GKGoal(toReachTargetSpeed: 0.0)
        setWeight(100.0, for: goal_speed!)
    }
    
    

}
