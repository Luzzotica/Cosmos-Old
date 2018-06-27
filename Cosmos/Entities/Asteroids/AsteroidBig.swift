//
//  AsteroidBig.swift
//  Cosmos
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class AsteroidBig : Asteroid {
    
    init(texture: SKTexture, gasTexture: SKTexture, minerals: Int) {
        let xy = sceneWidth * 0.16
        let aSize = CGSize(width: xy, height: xy)
        
        super.init(texture: texture, gasTexture: gasTexture, size: aSize, minerals: minerals)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
