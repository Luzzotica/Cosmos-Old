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

  init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
    super.init()
    if targetSpeed > 0 {
      setWeight(0.5, for: GKGoal(toReachTargetSpeed: targetSpeed))
      setWeight(1.0, for: GKGoal(toSeekAgent: seek))
//      setWeight(0.1, for: GKGoal(toAvoid: avoid, maxPredictionTime: 1.0))
    }
  }

}
