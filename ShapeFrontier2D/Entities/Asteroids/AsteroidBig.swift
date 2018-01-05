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
    
    init(minerals: Int) {
        let xy = sceneWidth * 0.04
        let aSize = CGSize(width: xy, height: xy)
        
        super.init(texture: nil, color: .green, size: aSize, minerals: minerals)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
