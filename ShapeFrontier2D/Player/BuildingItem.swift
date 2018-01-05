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
	
	var building : String! {
		didSet{
			nameLabel.text = building
			
			imageNode = SKSpriteNode()
			imageNode.size = CGSize(width: 60, height: 60)
			imageNode.color = .cyan
			//				imageNode = SKSpriteNode(texture: SKTexture(image: emoji.image))
			
			nameLabel.position.y = 0
			
			addChild(nameLabel)
			addChild(imageNode)
		}
	}
}
