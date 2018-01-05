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
	var maxEnergy = 100.0
	var currentEnergy = 100.0
	var currentMinerals = 0
	var HUDWidth: CGFloat!
	//	var currentEnergyLevelNode: SKSpriteNode
	var energyLevelNode: SKSpriteNode!
	
	
	var lastEnergyUpdate : TimeInterval = 0.0
	var timeModifier : Double = 0.0000007
	
	func setupEnergyBar(width: CGFloat) -> SKSpriteNode {
		
		HUDWidth = width
		let height = sceneHeight * 0.05
		energyLevelNode = SKSpriteNode(color: .cyan, size: CGSize(width: HUDWidth, height: height))
		energyLevelNode.zPosition = Layer.UI
		
		// Set his position to left side of gamescreen
		energyLevelNode.position.y = sceneHeight * 0.01
		energyLevelNode.position.x = -HUDWidth - (sceneWidth * 0.01)
		energyLevelNode.anchorPoint.y = 0.0
		energyLevelNode.anchorPoint.x = 0.0	
		
		return energyLevelNode
	}
	
	func energyUsed(amount: Double) {
		currentEnergy -= amount
		
		updateEnergyMeter()
	}
	
	func energyGained(amount: Double) {
		currentEnergy += amount
		
		if currentEnergy > maxEnergy {
			currentEnergy = maxEnergy
		}
		
		updateEnergyMeter()
	}
	
	func hasEnergy(amount: Double) -> Bool {
		if currentEnergy >= amount {
			energyUsed(amount: amount)
			return true
		}
		else {
			return false
		}
	}
	
	func updateEnergyMeter() {
		energyLevelNode.size.width = HUDWidth * CGFloat(currentEnergy * 0.01)
	}
	
	func energyOverTime(time: TimeInterval) {
		var elapsed = time - lastEnergyUpdate
		//print(elapsed)
		elapsed *= timeModifier
		energyGained(amount: elapsed)
	}
	
	func reset() {
		currentEnergy = maxEnergy
		
		updateEnergyMeter()
	}
	
}
