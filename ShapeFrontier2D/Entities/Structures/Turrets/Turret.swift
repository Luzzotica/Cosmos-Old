//
//  Turret.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Turret : Structure {
    
    var range : CGFloat = 0.0
    
    override init(texture: SKTexture, size: CGSize, team: Team) {
        super.init(texture: texture, size: size, team: team)
        
        mySprite.name! += "_turret"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
