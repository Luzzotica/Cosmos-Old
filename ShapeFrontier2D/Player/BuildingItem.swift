//
//  BuildingItem.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

import CollectionNode


class BuildingItem: NSObject {
    
	private var nameLabel : SKLabelNode = SKLabelNode()
	
	var building : Structure! {
		didSet {
            nameLabel.text = building.name
            nameLabel.fontName = fontStyleN
            nameLabel.fontSize = fontSizeN
            
            nameLabel.position.y = fontSizeN * 0.5
            
            building.addChild(nameLabel)
		}
	}
    
    init(_ structure: Structure) {
        super.init()
        
        building = structure
        building.name?.append("Constructor")
    }
}
