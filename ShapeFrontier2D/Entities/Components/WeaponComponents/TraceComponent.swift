//
//  TraceComponent.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 4/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class TraceComponent : GKAgent2D, GKAgentDelegate {
    
    var target : GKAgent2D?
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, target: GKAgent2D) {
        self.target = target
        
        super.init()
        self.delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.01
        
        // Create a behavior to seek out the enemy!
        let behavior = GKBehavior()
        if self.target != nil {
            behavior.setWeight(1, for: GKGoal(toInterceptAgent: target, maxPredictionTime: 0.0))
            behavior.setWeight(5, for: GKGoal(toReachTargetSpeed: maxSpeed))
        }
        
        // Add the behavior to our agent
        self.behavior = behavior
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        // Update the agent right before he's about to do stuff so he's in line with the sprite
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2(spriteComponent.node.position)
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        
        // Need to update the sprite after the agent has executed his actions
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
        spriteComponent.node.physicsBody!.velocity = CGVector(velocity)
        spriteComponent.spriteNode.zRotation = CGFloat(rotation - .pi/2.0)
        
        // Get target sprite component
        guard let targetSprite = target?.entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        if targetSprite.node.parent == nil {
            target = nil
            EntityManager.shared.remove(entity!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
