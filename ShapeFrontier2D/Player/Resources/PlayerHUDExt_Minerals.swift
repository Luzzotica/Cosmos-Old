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
        mineralNode.addChild(setupMineralLabel())
        mineralNode.addChild(setupMiningRateLabel())
        return mineralNode
    }
	
	func setupMineralLabel() -> SKLabelNode {
		mineralsLevelLabel = SKLabelNode(text: "\(gameScene.minerals_current) minerals")
		mineralsLevelLabel.fontSize = fontSizeS
		mineralsLevelLabel.fontName = fontStyleN
		mineralsLevelLabel.fontColor = .green
		
		// Set position to bottom-right of screen
		mineralsLevelLabel.position.y = fontSizeS * 1.1
		mineralsLevelLabel.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		mineralsLevelLabel.horizontalAlignmentMode = .left
		mineralsLevelLabel.verticalAlignmentMode = .bottom
		
		return mineralsLevelLabel
	}
	
    func setupMiningRateLabel() -> SKLabelNode {
		mininigRateLabel = SKLabelNode(text: "\(gameScene.minerals_current) per minute")
		mininigRateLabel.fontSize = fontSizeS
		mininigRateLabel.fontName = fontStyleN
		mininigRateLabel.fontColor = .green
		
		// Set position to bottom-right of screen
		mininigRateLabel.position.y = 0.0
		mininigRateLabel.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		mininigRateLabel.horizontalAlignmentMode = .left
		mininigRateLabel.verticalAlignmentMode = .bottom
		
		return mininigRateLabel
	}
	
	func update_mineralsLabel() {
		mininigRateLabel.text = "\(gameScene.minerals_current) m / minute"
		mineralsLevelLabel.text = "\(gameScene.minerals_current) minerals"
	}
	
}
