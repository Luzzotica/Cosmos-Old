//
//  PlayerEnergyBarHandler.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit


class PlayerEnergyBarHandler: NSObject {
	var maxEnergy: Int = 1
	var currentEnergy: Int = 10
	var HUDWidth: CGFloat!

	var energyLevelNode: SKSpriteNode!
	var energyLevelLabel: SKLabelNode!
	
	
	var lastEnergyUpdate : TimeInterval = 0.0
	var timeModifier : Double = 0.0000007
	
	func setupEnergyBar(width: CGFloat) -> SKNode {
		
		HUDWidth = width
		let height = sceneHeight * 0.03
		energyLevelNode = SKSpriteNode(color: .cyan, size: CGSize(width: HUDWidth, height: height))
		energyLevelNode.zPosition = Layer.UI
		
		// Set position to bottom-right of screen
		energyLevelNode.position.y = sceneHeight * 0.01
		energyLevelNode.position.x = -HUDWidth - (sceneWidth * 0.01)
		energyLevelNode.anchorPoint.y = 0.0
		energyLevelNode.anchorPoint.x = 0.0	
		
		return energyLevelNode
	}
	
	func setupEnergyLabel(baseValue : Int) -> SKLabelNode {
		// Start with full energy
		currentEnergy = baseValue
		maxEnergy = baseValue
		
		energyLevelLabel = SKLabelNode(text: "\(currentEnergy) energy (\(100 * currentEnergy / maxEnergy)%)")
		energyLevelLabel.fontSize = fontSizeS
		energyLevelLabel.fontName = fontStyleN
		energyLevelLabel.fontColor = .cyan
		
		// Set position to bottom-right of screen
		energyLevelLabel.position.y = energyLevelNode.size.height + sceneHeight * 0.015
		energyLevelLabel.position.x = -HUDWidth - (sceneWidth * 0.01)
		energyLevelLabel.horizontalAlignmentMode = .left
		
		return energyLevelLabel
	}
	
	func energyUsed(amount: Int) {
		gameScene.power_current -= amount
		
		updateEnergyMeter()
	}
	
	func updateMaxEnergy(amount: Int) {
		gameScene.power_capacity = amount
	}
	
	func energyGained(amount: Int) {
//        gameScene.power_total += amount
//
//        if gameScene.power_total > gameScene.power_capacity {
//            gameScene.power_total = gameScene.power_capacity
//        }
		
		updateEnergyMeter()
	}
	
	func hasEnergy(amount: Int) -> Bool {
		if currentEnergy >= amount {
			energyUsed(amount: amount)
			return true
		}
		else {
			return false
		}
	}
	
	func updateEnergyMeter() {
		energyLevelNode.size.width = HUDWidth * CGFloat(gameScene.power_current / gameScene.power_capacity)
		energyLevelLabel.text = "\(gameScene.power_current) energy (\(gameScene.power_current / gameScene.power_capacity * 100)%)"
	}
	
	func energyOverTime(time: TimeInterval) {
		var elapsed = time - lastEnergyUpdate
		//print(elapsed)
		elapsed *= timeModifier
		energyGained(amount: Int(elapsed))
	}
	
	func reset() {
		currentEnergy = maxEnergy
		
		updateEnergyMeter()
	}
	
}
