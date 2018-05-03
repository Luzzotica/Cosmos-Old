//
//  BuildingItem.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class ConstructionItem: NSObject {
    
	private var nameLabel : SKLabelNode = SKLabelNode()
	
    var buildingSprite : SKSpriteNode!
    
    init(_ structure: Structure) {
        super.init()
        
        // Get his spriteComponent and name!
        let spriteComponent = structure.component(ofType: SpriteComponent.self)
        buildingSprite = spriteComponent?.spriteNode
        
        // Set his name, this is how we recognize him!
        spriteComponent!.node.name! += "_constructor"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
