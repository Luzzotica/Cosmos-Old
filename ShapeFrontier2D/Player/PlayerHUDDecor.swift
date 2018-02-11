//
//  PlayerHUDDecor.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 2/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerHUDDecor : NSObject {
    
    static let shared = PlayerHUDDecor()
    
    func createConstructionViewBackground() -> SKSpriteNode {
        let nodeSize = CGSize(width: sceneWidth, height: sceneHeight * 0.275)
        let node = SKSpriteNode(color: .darkGray, size: nodeSize)
        
        // Move him down to the bottom
        node.position.y = sceneHeight * -0.5
        node.anchorPoint.y = 0.0
        
        return node
    }
}
