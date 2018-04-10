//
//  File.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/2/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class AsteroidComponent : GKComponent {
    
    var minerals_max : Int
    var minerals_current : Int
    
    let gasSprite : SKSpriteNode
    
    init(minerals: Int, gasSprite: SKSpriteNode) {
        minerals_max = minerals
        minerals_current = minerals
        
        self.gasSprite = gasSprite
        
        super.init()
    }
    
    func getMineAmount(amount: Int) -> Int {
        var amountMined = 0
        if amount > minerals_current {
            amountMined = minerals_current
            minerals_current = 0
            gasSprite.alpha = 0.0
        }
        else {
            amountMined = amount
            minerals_current -= amount
            gasSprite.alpha = CGFloat(minerals_current) / CGFloat(minerals_max)
        }
        
        return amountMined
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
