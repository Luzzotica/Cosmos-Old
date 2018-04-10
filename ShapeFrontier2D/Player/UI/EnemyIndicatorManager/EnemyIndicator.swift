//
//  EnemyDetectionLine.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/30/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyIndicator : SKSpriteNode {
    
    static let indicatorSize = CGSize(width: sceneWidth * 0.05, height: sceneWidth * 0.01)
    static let indicatorOffset : CGFloat = sceneWidth * 0.06
    
    let target : SKNode
    
    init(target: SKNode) {
        self.target = target
        
        super.init(texture: nil, color: .red, size: EnemyIndicator.indicatorSize)
    }
    
    func update() {
        // If the target is dead
        if target.parent == nil {
            return
        }
        
        // Get the angle and rotate it. Not sure why I need to rotate it a little bit
        var angleToEnemy = angleBetweenPoints(point1: parent!.parent!.position, point2: target.position)
        angleToEnemy += .pi/2
        
        // Rotate and move
        zRotation = angleToEnemy
        position.x = EnemyIndicator.indicatorOffset * cos(angleToEnemy)
        position.y = EnemyIndicator.indicatorOffset * sin(angleToEnemy)
        
        // Scale based on distance
        let distance = getDistance(point1: parent!.parent!.position, point2: target.position)
        
        
        // If they are in the screen area, hide the indicator, they can see them
        if distance < sceneWidth * 0.5 * PlayerHUD.shared.xScale {
            isHidden = true
        }
        else {
            isHidden = false
            let length = min(distance * 0.02, EnemyIndicator.indicatorSize.width)
            size.width = length
        }
        
//        size.width = length
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
