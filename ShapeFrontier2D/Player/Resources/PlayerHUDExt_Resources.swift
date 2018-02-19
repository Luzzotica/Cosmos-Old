//
//  PlayerResourcesManager.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

extension PlayerHUD {
	
	func setupResourceView() {
        // Anchor this node at the bottom right of the screen
        resourceNode.position.x = sceneWidth * 0.5
        resourceNode.position.y = -sceneHeight * 0.5
        
        // Setup Resource HUD
        resourceNode.addChild(setupPowerNode())
        resourceNode.addChild(setupMineralNode())
        
        // Position the nodes correctly
        powerNode.position.y += sceneHeight * 0.05
        mineralNode.position.y += sceneHeight * 0.15
	}
    
    func update_resources() {
        // Update both resources at the same time
        update_powerLabel()
        update_mineralsLabel()
    }
}
