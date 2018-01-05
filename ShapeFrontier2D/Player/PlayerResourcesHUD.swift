//
//  PlayerResourcesManager.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerResourcesHUD: SKNode {
	var HUDWidth: CGFloat
	
	let playerEnergyBarHandler = PlayerEnergyBarHandler()
	
	override init() {
		self.HUDWidth = sceneWidth * 0.2
		
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func setup() -> Void {
		self.zPosition = Layer.UI
		self.position.x = sceneWidth / 2
		self.position.y = -sceneHeight / 2
		
		self.addChild(playerEnergyBarHandler.setupEnergyBar(width: HUDWidth))
	}
}
