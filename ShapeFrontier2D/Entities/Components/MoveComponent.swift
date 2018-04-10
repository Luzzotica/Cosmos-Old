//
//  SpriteAgent.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MoveComponent : GKAgent2D, GKAgentDelegate {
    
    // The target he tries to attack!
    var name : String
    var target : Int = 1
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, name: String) {
        self.name = name
        
        super.init()
        self.delegate = self
        self.maxSpeed = maxSpeed * 0.000005
        self.maxAcceleration = maxAcceleration * 0.001
        self.radius = radius
        self.mass = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        // Update the agent right before he's about to do stuff so he's in line with the sprite
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
//        print("got here")
        position = float2(spriteComponent.node.position)
        
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        // Need to update the sprite after the agent has executed his actions
        
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
        spriteComponent.node.physicsBody!.velocity = CGVector(velocity)
        spriteComponent.node.zRotation = CGFloat(rotation - .pi/2.0)
    }
    
    func closestAgentInGroup(agents: [MoveComponent]) -> MoveComponent? {
        if agents.count == 0 {
            return nil
        }
        
        // The clostest agent we want to attack
        var closestAgentComponent: MoveComponent? = nil
        
        // Keep track of the closest distance
        var closestDistance : CGFloat = 0
        
        // Loop through all of the target agents and find the closest one
//        let targetAgentComponents = EntityManager.shared.agentComponentsForPlayer(target)
        for targetAgentComponent in agents {
            let distance = (CGPoint(targetAgentComponent.position) - CGPoint(position)).length()
            if closestAgentComponent == nil || distance < closestDistance {
                closestAgentComponent = targetAgentComponent
                closestDistance = distance
            }
        }
        
        // If we are close enough, stop
        let distanceCheck = closestAgentComponent!.radius + radius
        if Float(closestDistance) < distanceCheck + Float(sceneWidth * 0.1) {
//            print("Closest Dist: \(closestDistance), compared to \(closestAgentComponent!.radius * 1.3 + radius)")
            return nil
        }
        
        // Return the closest agent from the target player that we found
        return closestAgentComponent
        
    }
    
    func getAgentsForPlayer() -> [MoveComponent] {
        return EntityManager.shared.agentComponentsForPlayer(target)
    }
    
    func getObstacles() -> [GKAgent] {
        return EntityManager.shared.agentComponentsForPlayer(0)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        // If we have no speed... do nothing
        if maxSpeed == 0 {
            // Update the GKAgents position
            guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
                return
            }
            position = float2(spriteComponent.node.position)
            return
        }
//        print(maxSpeed)
        super.update(deltaTime: seconds)

        // Get the targets I will want to chase
        let toAttack = getAgentsForPlayer()
        
        // Find closest agent in the target player
        let targetMoveComponent = closestAgentInGroup(agents: toAttack)
        
        if targetMoveComponent == nil {
            behavior = MoveBehavior()
        }
        else {
            behavior = MoveBehavior(targetSpeed: maxSpeed,
                                    seek: targetMoveComponent!,
                                    avoid: getObstacles())
        }
        
        
    }
    
}

