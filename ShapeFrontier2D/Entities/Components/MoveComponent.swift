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
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float) {
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed * 0.00001
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        print(self.mass)
        self.mass = 0.01
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func agentWillUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        position = float2(spriteComponent.node.position)
        rotation = Float(spriteComponent.node.zRotation - .pi/2.0)
    }
    
    func agentDidUpdate(_ agent: GKAgent) {
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
        spriteComponent.node.zRotation = CGFloat(rotation - .pi/2)
    }
    
    func closestMoveComponentOnTeam(_ team: Team) -> GKAgent2D? {
        
        var closestMoveComponent: MoveComponent? = nil
        var closestDistance = CGFloat(0)
        
        let enemyMoveComponents = EntityManager.shared.moveComponentsOnTeam(team)
        for enemyMoveComponent in enemyMoveComponents {
            let distance = (CGPoint(enemyMoveComponent.position) - CGPoint(position)).length()
            if closestMoveComponent == nil || distance > closestDistance {
                closestMoveComponent = enemyMoveComponent
                closestDistance = distance
            }
        }
        return closestMoveComponent
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if maxSpeed == 0 {
            return
        }
        print(maxSpeed)
        super.update(deltaTime: seconds)
        
        
        var targetMoveComponent: GKAgent2D
        
        guard let teamComponent = entity!.component(ofType: TeamComponent.self) else {
            return
        }
        
        // Find closest enemy
        guard let enemyMoveComponent = closestMoveComponentOnTeam(teamComponent.team.oppositeTeam()) else {
            return
        }
        targetMoveComponent = enemyMoveComponent
        
        // Reset behavior
        print(targetMoveComponent)
        behavior = MoveBehavior(targetSpeed: maxSpeed, seek: targetMoveComponent, avoid: [])
        
    }
    
}
