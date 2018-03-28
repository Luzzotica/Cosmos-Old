//
//  SpriteComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameplayKit

//class EntityNode: SKSpriteNode {
//  weak var entity: GKEntity!
//}

class SpriteComponent: GKComponent {
    //
    //  // A node that gives an entity a visual sprite
    //  let node: EntityNode
    let node: SKSpriteNode

    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKSpriteNode(texture: texture,
                        color: SKColor.white, size: size)
        super.init()
        
        node.entity = entity
        
        // Setup his physics body
        node.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
    }
    
    init(entity: GKEntity, size: CGSize) {
        node = SKSpriteNode(color: SKColor.red, size: size)
        super.init()
        
        node.entity = entity
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
    }
    
    override func didAddToEntity() {
        node.entity = entity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

