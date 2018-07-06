//
//  SpriteComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 3/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {
    
    let spriteNode: SKSpriteNode
    let node: SKNode
    
    func setSpriteTexture(texture: SKTexture) {
        spriteNode.texture = texture
    }
    
    func select(toAdd: [SKNode]) {
        for i in 0..<toAdd.count {
            node.addChild(toAdd[i])
        }
    }
    
    func deselect() {
        for i in stride(from: node.children.count - 1, through: 0, by: -1) {
            if node.children[i].name != nil &&
                node.children[i].name!.contains("selection") {
                node.children[i].removeFromParent()
            }
        }
    }

    init(texture: SKTexture, size: CGSize) {
        node = SKNode()
        spriteNode = SKSpriteNode(texture: texture,
                        color: SKColor.white, size: size)
        
        super.init()
        
        
        // Setup his physics body
        node.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
        
        node.addChild(spriteNode)
    }
    
    init(size: CGSize) {
        node = SKNode()
        spriteNode = SKSpriteNode(color: SKColor.red, size: size)
        
        super.init()
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
        
        node.addChild(spriteNode)
    }
    
    override func didAddToEntity() {
        node.entity = entity
        spriteNode.entity = entity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}

class entityNode : SKNode {
    override var name: String? {
        didSet {
            self.setSpriteName(name: name!)
        }
    }
    
    func setSpriteName(name: String) {
        
    }
    
}

