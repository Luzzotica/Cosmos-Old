//
//  Asteroid.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Asteroid : Entity {
    
    var minerals_current : Int = 0
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, minerals: Int) {
        super.init(texture: texture, color: color, size: size)
        
        
        
        minerals_current = minerals
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
