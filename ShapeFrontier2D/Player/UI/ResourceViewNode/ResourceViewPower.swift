//
//  PlayerEnergyBarHandler.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit


extension ResourceViewNode {
	
    func setupPowerNode() -> SKNode {
        let node = SKNode()
        
        // Setup the power bar and label
        powerLevelNode = setupPowerBar()
        powerLevelLabel = setupPowerLabel()
        
        // Add them to the powerNode in the resource view
        node.addChild(powerLevelNode)
        node.addChild(powerLevelLabel)
        
        return node
    }
    
	func setupPowerBar() -> SKSpriteNode {
        // Create the power bar and make him the width of the resourceHUDWidth
		let height = sceneHeight * 0.03
		let powerLevelNode = SKSpriteNode(color: .cyan, size: CGSize(width: resourceHUDWidth, height: height))
		powerLevelNode.zPosition = 1
		
		// Set position to bottom-right of screen
        // Don't move him up he is based at the bottom of the powerHUD
		powerLevelNode.position.y = 0.0
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buf
		powerLevelNode.position.x = leftAnchor - (sceneWidth * 0.01)
		powerLevelNode.anchorPoint.y = 0.0
		powerLevelNode.anchorPoint.x = 0.0	
		
		return powerLevelNode
	}
	
	func setupPowerLabel() -> SKLabelNode {
		// Create the ppowerlevel label
		let powerLevelLabel = SKLabelNode(text: "")
		powerLevelLabel.fontSize = fontSizeS
		powerLevelLabel.fontName = fontStyleN
		powerLevelLabel.fontColor = .cyan
		
		// Set position to bottom-right of screen
        // Move him up based on fontSize
		powerLevelLabel.position.y = fontSizeS * 1.1
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buf
		powerLevelLabel.position.x = leftAnchor - (sceneWidth * 0.01)
		powerLevelLabel.horizontalAlignmentMode = .left
		
		return powerLevelLabel
	}
	
	func update_powerLabel() {
        // Update the powerlevel label and the power bar. Increase/decrease it's width
		powerLevelNode.size.width = -leftAnchor * CGFloat(gameScene.player_powerCurrent) / CGFloat(gameScene.player_powerCapacity)
        if gameScene.player_powerCapacity == 0 {
            powerLevelLabel.text = "No power!"
        }
        else {
            powerLevelLabel.text = "\(gameScene.player_powerCurrent) energy (\(Int(CGFloat(gameScene.player_powerCurrent) / CGFloat(gameScene.player_powerCapacity) * 100.0))%)"
        }
		
	}
	
}
