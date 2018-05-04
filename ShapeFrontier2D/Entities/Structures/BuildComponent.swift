//
//  BuildComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 5/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class BuildComponent: GKComponent {
    
    var build_ticks : Int
    var build_power : Int
    
    var currentTime : TimeInterval = 0
    
    init(ticks: Int, power: Int) {
        build_ticks = ticks
        build_power = power
        
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        currentTime += seconds
        
    }
    
}
