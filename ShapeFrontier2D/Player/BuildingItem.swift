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


class BuildingItem: CollectionNodeItem {
	private var nameLabel : SKLabelNode = SKLabelNode()
	private var imageNode : SKSpriteNode!
	
	var building : Structure! {
		didSet {
			nameLabel.text = building.name
			
			imageNode = SKSpriteNode(texture: building.texture)
			imageNode.size = CGSize(width: 60, height: 60)
			imageNode.color = building.color
			nameLabel.position.y = 0
			
			
			addChild(nameLabel)
			addChild(imageNode)
		}
	}
}
