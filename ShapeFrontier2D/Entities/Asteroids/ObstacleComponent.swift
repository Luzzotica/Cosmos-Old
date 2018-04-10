//
//  ObstacleComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/9/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class ObstacleComponent: GKComponent {
    
    var obstacle : GKCircleObstacle
    
    init(position: CGPoint, radius: CGFloat) {
        obstacle = GKCircleObstacle(radius: Float(radius))
        obstacle.position = float2(position)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
