//
//  PlayerEnergyBarHandler.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit


extension PlayerHUD {
	
    func setupPowerNode() -> SKNode {
        // Setup the power node
        powerNode.addChild(setupPowerBar())
        powerNode.addChild(setupPowerLabel())
        return powerNode
    }
    
	func setupPowerBar() -> SKNode {
        // Create the power bar and make him the width of the resourceHUDWidth
		let height = sceneHeight * 0.03
		powerLevelNode = SKSpriteNode(color: .cyan, size: CGSize(width: resourceHUDWidth, height: height))
		powerLevelNode.zPosition = Layer.UI
		
		// Set position to bottom-right of screen
        // Don't move him up he is based at the bottom of the powerHUD
		powerLevelNode.position.y = 0.0
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buf
		powerLevelNode.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		powerLevelNode.anchorPoint.y = 0.0
		powerLevelNode.anchorPoint.x = 0.0	
		
		return powerLevelNode
	}
	
	func setupPowerLabel() -> SKLabelNode {
		// Create the ppowerlevel label
		powerLevelLabel = SKLabelNode(text: "")
		powerLevelLabel.fontSize = fontSizeS
		powerLevelLabel.fontName = fontStyleN
		powerLevelLabel.fontColor = .cyan
		
		// Set position to bottom-right of screen
        // Move him up based on fontSize
		powerLevelLabel.position.y = fontSizeS * 1.1
        // Move to the left the resourceHUDWidth, and a little of the sceneWidth for buf
		powerLevelLabel.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		powerLevelLabel.horizontalAlignmentMode = .left
		
		return powerLevelLabel
	}
	
	func update_powerLabel() {
        // Update the powerlevel label and the power bar. Increase/decrease it's width
		powerLevelNode.size.width = resourceHUDWidth * CGFloat(gameScene.player_powerCurrent) / CGFloat(gameScene.player_powerCapacity)
        if gameScene.player_powerCapacity == 0 {
            powerLevelLabel.text = "You currently have no power!"
        }
        else {
            powerLevelLabel.text = "\(gameScene.player_powerCurrent) energy (\(Int(CGFloat(gameScene.player_powerCurrent) / CGFloat(gameScene.player_powerCapacity) * 100.0))%)"
        }
		
	}
	
}
