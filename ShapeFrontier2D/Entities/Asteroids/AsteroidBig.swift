//
//  AsteroidBig.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class AsteroidBig : Asteroid {
    
    init(texture: SKTexture, minerals: Int) {
        let xy = sceneWidth * 0.16
        let aSize = CGSize(width: xy, height: xy)
        
        super.init(texture: texture, size: aSize, minerals: minerals)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
