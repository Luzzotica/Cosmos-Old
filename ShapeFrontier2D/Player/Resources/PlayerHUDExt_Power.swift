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
        powerNode.addChild(setupPowerBar())
        powerNode.addChild(setupPowerLabel())
        return powerNode
    }
    
	func setupPowerBar() -> SKNode {
        
		let height = sceneHeight * 0.03
		powerLevelNode = SKSpriteNode(color: .cyan, size: CGSize(width: resourceHUDWidth, height: height))
		powerLevelNode.zPosition = Layer.UI
		
		// Set position to bottom-right of screen
		powerLevelNode.position.y = 0.0
		powerLevelNode.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		powerLevelNode.anchorPoint.y = 0.0
		powerLevelNode.anchorPoint.x = 0.0	
		
		return powerLevelNode
	}
	
	func setupPowerLabel() -> SKLabelNode {
		
		powerLevelLabel = SKLabelNode(text: "\(gameScene.power_current) energy (\(100 * gameScene.power_current / gameScene.power_capacity)%)")
		powerLevelLabel.fontSize = fontSizeS
		powerLevelLabel.fontName = fontStyleN
		powerLevelLabel.fontColor = .cyan
		
		// Set position to bottom-right of screen
		powerLevelLabel.position.y = fontSizeS * 1.1
		powerLevelLabel.position.x = -resourceHUDWidth - (sceneWidth * 0.01)
		powerLevelLabel.horizontalAlignmentMode = .left
		
		return powerLevelLabel
	}
	
	func update_powerLabel() {
		powerLevelNode.size.width = resourceHUDWidth * CGFloat(gameScene.power_current) / CGFloat(gameScene.power_capacity)
		powerLevelLabel.text = "\(gameScene.power_current) energy (\(Int(CGFloat(gameScene.power_current) / CGFloat(gameScene.power_capacity) * 100.0))%)"
	}
	
}
