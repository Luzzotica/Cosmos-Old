//
//  ObstacleComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/14/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class ObstacleComponent : GKComponent {
    
    let obstacle : GKCircleObstacle
    
    init(position: float2, radius: Float) {
        
        obstacle = GKCircleObstacle(radius: radius)
        obstacle.position = position
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

