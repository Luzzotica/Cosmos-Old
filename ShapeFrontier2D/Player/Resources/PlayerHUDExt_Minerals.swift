//
//  PlayerMiningHandler.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit

extension PlayerHUD {
    
    func setupMineralNode() -> SKNode  {
        // Setup up the mineral node with current minerals, and mining rate
        mineralNode.addChild(setupMineralLabel())
        mineralNode.addChild(setupMiningRateLabel())
        return mineralNode
    }
	
	func setupMineralLabel() -> SKLabelNode {
        // Create the minerals label
		mineralsLevelLabel = SKLabelNode(text: "\(gameScene.minerals_current) minerals")
		mineralsLevelLabel.fontSize = fontSizeS
		mineralsLevelLabel.fontName = fontStyleN
		mineralsLevelLabel.fontColor = .green
		
		// Set position to bottom-right of screen
        // Move up based on fontSize
		mineralsLevelLabel.position.y = fontSizeS * 1.1
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buffer
		mineralsLevelLabel.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		mineralsLevelLabel.horizontalAlignmentMode = .left
		mineralsLevelLabel.verticalAlignmentMode = .bottom
		
		return mineralsLevelLabel
	}
	
    func setupMiningRateLabel() -> SKLabelNode {
        // Setup mining rate label
		mininigRateLabel = SKLabelNode(text: "\(gameScene.minerals_current) per minute")
		mininigRateLabel.fontSize = fontSizeS
		mininigRateLabel.fontName = fontStyleN
		mininigRateLabel.fontColor = .green
		
		// Set position to bottom-right of screen
        // Doesn't need to be moved up, he's at the bottom of the mineralNode
		mininigRateLabel.position.y = 0.0
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buf
		mininigRateLabel.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		mininigRateLabel.horizontalAlignmentMode = .left
		mininigRateLabel.verticalAlignmentMode = .bottom
		
		return mininigRateLabel
	}
	
	func update_mineralsLabel() {
        // Update the minerals from the gameScene
		mininigRateLabel.text = "\(gameScene.minerals_current) mins / minute"
		mineralsLevelLabel.text = "\(gameScene.minerals_current) minerals"
	}
	
}
