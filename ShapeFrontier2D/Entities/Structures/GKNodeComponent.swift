//
//  GKNodeComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/14/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class GKGraphNodeComponent : GKComponent {
    
    var node : GKGraphNode2D
    
    init(position: CGPoint) {
        node = GKGraphNode2D(point: float2(position))
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
