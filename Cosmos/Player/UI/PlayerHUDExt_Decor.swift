//
//  PlayerHUDExt_Decor.swift
//  Cosmos
//
//  Created by Sterling Long on 2/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit

extension PlayerHUD {
    
    func createConstructionViewBackground() -> SKSpriteNode {
        let nodeSize = CGSize(width: sceneWidth, height: bottomBar_height + bottomBar_buffer)
        let node = SKSpriteNode(color: .darkGray, size: nodeSize)
        
        // Set his anchor point to the bottom
        node.anchorPoint.y = 0.0
        
        return node
    }
}
