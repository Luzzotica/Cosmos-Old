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
	
	var building : Structure!
    
    init(_ structure: Structure) {
        super.init()
        
//        // Label above it
//        nameLabel = SKLabelNode(text: structure.name)
//        nameLabel.fontName = fontStyleN
//        nameLabel.fontSize = fontSizeN
//        nameLabel.horizontalAlignmentMode = .center
//        
//        nameLabel.position.y = fontSizeN * 0.5
        
        // Build stuff
        building = structure
        building.name?.append("Constructor")
        
        building.addChild(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
