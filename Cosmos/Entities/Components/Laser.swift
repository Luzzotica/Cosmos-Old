//
//  Laser.swift
//  Cosmos
//
//  Created by Sterling Long on 2/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

class Laser : SKSpriteNode {
    
    static var laserAnimations : [Int:SKAction] = [:]
    
    var nodeOne : SKNode?
    var nodeTwo : SKNode?
    
    var width : CGFloat = 10
    
    var laser_color : UIColor?
    
    func destroySelf() {
        removeFromParent()
        nodeOne = nil
        nodeTwo = nil
    }
    
    static func prepareLaserAnimation() {
        let wait = SKAction.wait(forDuration: 0.2)
        let fadeout = SKAction.fadeOut(withDuration: 0.3)
        let sequence = SKAction.sequence([wait, fadeout])
        Laser.laserAnimations[0] = sequence
    }
    
    init(nodeOne: SKNode, nodeTwo: SKNode, color: UIColor, width: CGFloat) {
        super.init(texture: nil, color: color, size: CGSize.zero)
        
        self.nodeOne = nodeOne
        self.nodeTwo = nodeTwo
        
        self.width = width
        
        //Set color for everything
        self.laser_color = color
        
        self.zPosition = 5
        
        update()
    }
    
    func animate(animationType: Int)
    {
        run(Laser.laserAnimations[animationType]!) {
            self.destroySelf()
        }
    }
    
    func update() {
        // Get the distance and angle between the two nodes
        let distance = (nodeOne!.position - nodeTwo!.position).length()
        let angle = angleBetweenPoints(point1: nodeOne!.position, point2: nodeTwo!.position)
        
        // Anchor ourselves at 0 on the y
        anchorPoint.y = 0.0
        
        // Rotate and stretch ourselves so we hit both nodes
        size = CGSize(width: width, height: distance)
        zRotation = angle
        
        // Add a ball at the beginning and the end
        let ball = SKShapeNode(circleOfRadius: width * 1.5)
        let start_ball = SKShapeNode(circleOfRadius: width)
        
        ball.fillColor = laser_color!
        start_ball.fillColor = laser_color!
        ball.strokeColor = laser_color!
        start_ball.strokeColor = laser_color!
        
        ball.position = CGPoint(x: 0.0, y: distance)
        
        addChild(ball)
        addChild(start_ball)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
