//
//  Laser.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 2/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit

class Laser : NSObject {
    
    static var laserAnimations : [Int:SKAction] = [:]
    
    var entityOne : Entity?
    var entityTwo : Entity?
    var laser : SKShapeNode?
    
    var toDestroy = false
    
    func update() {
        if entityOne == nil || entityTwo == nil {
            destroySelf()
            return
        }
        
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: entityOne!.position - entityTwo!.position)
        
        laser?.path = path
    }
    
    func destroySelf() {
        laser?.removeFromParent()
        toDestroy = true
        entityOne = nil
        entityTwo = nil
    }
    
    static func prepareLaserAnimation() {
        for i in 0...EntityType.MaxType {
            if i == EntityType.Miner {
                let wait = SKAction.wait(forDuration: 0.2)
                let fadeout = SKAction.fadeOut(withDuration: 0.3)
                let sequence = SKAction.sequence([wait, fadeout])
                Laser.laserAnimations[EntityType.Miner] = sequence
            }
        }
    }
    
    init(entOne: Entity, entTwo: Entity, color: UIColor, width: CGFloat, entityType: Int) {
        super.init()
        
        entityOne = entOne
        entityTwo = entTwo
        
        // Create a path
        let path: CGMutablePath = CGMutablePath()
        
        path.move(to: CGPoint.zero)
        
        let pointOne = entityOne!.position
        let pointTwo = entityTwo!.position
        path.addLine(to: pointTwo - pointOne)
        path.addLine(to: CGPoint.zero)
        
        // Create a line out of it
        laser = SKShapeNode(path: path)
        laser?.strokeColor = color
        laser?.lineWidth = width
        
        // Put a ball at the end of the line
        let ball = SKShapeNode(circleOfRadius: width * 2.0)
        ball.fillColor = .green
        ball.strokeColor = .clear
        ball.position = pointTwo - pointOne
        laser?.addChild(ball)
        
        // powerLine?.physicsBody = SKPhysicsBody(
        laser?.physicsBody?.categoryBitMask = CollisionType.PowerLine
        laser?.physicsBody?.contactTestBitMask = CollisionType.Construction
        
        // Add the line to the target structure
        entityOne?.addChild(laser!)
        
        laser?.run(Laser.laserAnimations[entityType]!) {
            self.destroySelf()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
