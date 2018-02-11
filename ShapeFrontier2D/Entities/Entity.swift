//
//  Entity.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Entity : SKSpriteNode {
    
    var health_max : Int = 0
    var health : Int = 0
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct EntityType {
    static let Miner = 0
    static let MissileTurret = 1
    static let PulseLaser = 2
    static let MaxType = 2
}
