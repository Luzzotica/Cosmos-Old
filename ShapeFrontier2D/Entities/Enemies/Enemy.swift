//
//  Enemy.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Enemy : Entity {
    
    let AI_handler : GKEntity = GKEntity()
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        name! += "_enemy"
        
        // Setup the AI_handler
        let trackingAgent = GKAgent()
        let weirdNode = GKSKNodeComponent(node: self)
        
        
        trackingAgent.delegate = weirdNode
        trackingAgent.maxSpeed = 100.0
        trackingAgent.speed = 50.0
        
        

        // Create goals for this guy
        let moveToStructureGoal = GKGoal(toReachTargetSpeed: 500.0)

        // Create a behavior to wander aimlessly
        let behavoir = GKBehavior.init(goal: moveToStructureGoal, weight: 1.0)

        trackingAgent.behavior = behavoir

        AI_handler.addComponent(weirdNode)
        AI_handler.addComponent(trackingAgent)
        self.entity = AI_handler
    }
    
    convenience init(texture: SKTexture) {
        let size = CGSize(width: sceneWidth * 0.06, height: sceneWidth * 0.06)
        self.init(texture: texture, color: .clear, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
