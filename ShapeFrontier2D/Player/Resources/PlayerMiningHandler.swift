//
//  PlayerMiningHandler.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit

class PlayerMiningHandler: NSObject {
    
	var currentMinerals: Int = 0
	var baseMinerals: Int = 0
	var mineralRatePerMin: Int = 0
	var baseRatePerMin: Int = 0
	var HUDWidth: CGFloat
	
	
	var mineralsLevelLabel: SKLabelNode!
	var mininigRateLabel: SKLabelNode!

	
	init(width: CGFloat) {
		self.HUDWidth = width
		
		super.init()
	}
	
	
	func setupMineralLevelLabel(baseValue: Int) -> SKLabelNode {
		baseMinerals = baseValue
		currentMinerals = baseValue
		
		mineralsLevelLabel = SKLabelNode(text: "\(currentMinerals) minerals")
		mineralsLevelLabel.fontSize = fontSizeS
		mineralsLevelLabel.fontName = fontStyleN
		mineralsLevelLabel.fontColor = .green
		
		// Set position to bottom-right of screen
		mineralsLevelLabel.position.y = mininigRateLabel.frame.origin.y + mininigRateLabel.frame.height + sceneHeight * 0.005
		mineralsLevelLabel.position.x = -HUDWidth - (sceneWidth * 0.01)
		mineralsLevelLabel.horizontalAlignmentMode = .left
		mineralsLevelLabel.verticalAlignmentMode = .bottom
		
		return mineralsLevelLabel
	}
	
	func setupMiningRateLabel(baseValue: Int, labelBelow: SKLabelNode) -> SKLabelNode {
		baseRatePerMin = baseValue
		mineralRatePerMin = baseValue
		
		mininigRateLabel = SKLabelNode(text: "\(currentMinerals) per minute")
		mininigRateLabel.fontSize = fontSizeS
		mininigRateLabel.fontName = fontStyleN
		mininigRateLabel.fontColor = .green
		
		// Set position to bottom-right of screen
		mininigRateLabel.position.y = labelBelow.frame.origin.y + labelBelow.frame.height + sceneHeight * 0.005
		mininigRateLabel.position.x = -HUDWidth - (sceneWidth * 0.01)
		mininigRateLabel.horizontalAlignmentMode = .left
		mininigRateLabel.verticalAlignmentMode = .bottom
		
		return mininigRateLabel
	}
	
	
	func mineralsUsed(amount: Int) {
		currentMinerals -= amount
		
		updateMineralsLabel()
	}
	
	func mineralsGained(amount: Int) {
		currentMinerals += amount
		
		updateMineralsLabel()
	}
	
	func hasEnergy(amount: Int) -> Bool {
		if currentMinerals >= amount {
			mineralsUsed(amount: amount)
			return true
		}
		else {
			return false
		}
	}
	
	func updateMineralsLabel() {
		mininigRateLabel.text = "\(currentMinerals) minerals per minute"
		mineralsLevelLabel.text = "\(currentMinerals) minerals"
	}
	
	func energyOverTime(time: TimeInterval) {
//		var elapsed = time - lastEnergyUpdate
//		//print(elapsed)
//		elapsed *= timeModifier
//		mineralsGained(amount: Int(elapsed))
	}
	
	func reset() {
		currentMinerals = baseMinerals
		
		updateMineralsLabel()
	}
	
}
