//
//  Reactor.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Reactor : Structure {
    
    
    
    var powerProvided : Int = 10
    
    override func setupStructure() {
        super.setupStructure()
        
        // setup health variables
        health_max = 10

        // Reactor power priority is low, doesn't need power...
        powerPriority = 0
        powerToBuild = 2
        powerToUse = 0
        
    }
    
    init() {
        let xy = sceneWidth * 0.12
        let rSize = CGSize(width: xy, height: xy)
        
        let reactorTexture = SKTexture(image: #imageLiteral(resourceName: "ReactorStage1"))
        
        super.init(texture: reactorTexture, color: .blue, size: rSize)
        
        setupStructure()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
