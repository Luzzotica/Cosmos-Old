//
//  PlayerResourcesManager.swift
//  ShapeFrontier2D
//
//  Created by Eric on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class ResourceViewNode : SKNode {
	
    var powerNode = SKNode()
    var mineralNode = SKNode()
    let resourceHUDWidth: CGFloat = sceneWidth * 0.3
    var leftAnchor : CGFloat!
    
    // Power variables
    var powerLevelNode: SKSpriteNode!
    var powerLevelLabel: SKLabelNode!
    let powerLevelBarHeight : CGFloat = sceneHeight * 0.04
    
    // Mineral variables
    var mineralsLevelLabel: SKLabelNode!
    var miningRateLabel: SKLabelNode!
    
    init(bottomBar_height: CGFloat, bottomBar_buffer: CGFloat)
    {
        super.init()
        
        leftAnchor = -resourceHUDWidth + bottomBar_buffer * 0.5
        
        // Anchor this node at the bottom right of the screen
        position.x = sceneWidth * 0.5
        position.y = 0.0
        
        // Setup powerNode and mineralNode
        powerNode = setupPowerNode()
        mineralNode = setupMineralNode()
        
        // Add the powerNode and mineralNode to the resource view
        addChild(powerNode)
        addChild(mineralNode)
        
        // Position the nodes correctly
        powerNode.position.y += bottomBar_height * 0.2
        mineralNode.position.y += bottomBar_height * 0.8
    }
    
    func update_resources() {
        // Update both resources at the same time
        update_powerLabel()
        update_mineralsLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
