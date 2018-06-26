//
//  PlayerComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerComponent : GKComponent {
    
    var player : Int
    
    init(player: Int) {
        self.player = player
        
        super.init();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
