//
//  PlayerMiningHandler.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit

extension ResourceViewNode {
    
    func setupMineralNode() -> SKNode  {
        let node = SKNode()
        
        // Setup up the mineral node with current minerals, and mining rate
        mineralsLevelLabel = setupMineralLabel()
        miningRateLabel = setupMiningRateLabel()
        
        // Add each one to the mineralNode
        node.addChild(mineralsLevelLabel)
        node.addChild(miningRateLabel)
        
        return node
    }
	
	func setupMineralLabel() -> SKLabelNode {
        // Create the minerals label
		let mineralsLevelLabel = SKLabelNode(text: "\(gameScene.minerals_current) minerals")
		mineralsLevelLabel.fontSize = fontSizeS
		mineralsLevelLabel.fontName = fontStyleN
		mineralsLevelLabel.fontColor = .green
		
		// Set position to bottom-right of screen
        // Move up based on fontSize
		mineralsLevelLabel.position.y = fontSizeS * 1.1
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buffer
		mineralsLevelLabel.position.x = leftAnchor - (sceneWidth * 0.01)
		mineralsLevelLabel.horizontalAlignmentMode = .left
		mineralsLevelLabel.verticalAlignmentMode = .bottom
		
		return mineralsLevelLabel
	}
	
    func setupMiningRateLabel() -> SKLabelNode {
        // Setup mining rate label
		let miningRateLabel = SKLabelNode(text: "\(gameScene.minerals_current) per minute")
		miningRateLabel.fontSize = fontSizeS
		miningRateLabel.fontName = fontStyleN
		miningRateLabel.fontColor = .green
		
		// Set position to bottom-right of screen
        // Doesn't need to be moved up, he's at the bottom of the mineralNode
		miningRateLabel.position.y = 0.0
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buf
		miningRateLabel.position.x = leftAnchor - (sceneWidth * 0.01)
		miningRateLabel.horizontalAlignmentMode = .left
		miningRateLabel.verticalAlignmentMode = .bottom
		
		return miningRateLabel
	}
	
	func update_mineralsLabel() {
        // Update the minerals from the gameScene
		miningRateLabel.text = "\(gameScene.minerals_current) mins / minute"
		mineralsLevelLabel.text = "\(gameScene.minerals_current) minerals"
	}
	
}
