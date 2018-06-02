//
//  SpriteComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
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

    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = SKNode()
        spriteNode = SKSpriteNode(texture: texture,
                        color: SKColor.white, size: size)
        
        super.init()
        node.entity = entity
        spriteNode.entity = entity
        
        // Setup his physics body
        node.physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
        
        node.addChild(spriteNode)
    }
    
    init(entity: GKEntity, size: CGSize) {
        node = SKNode()
        spriteNode = SKSpriteNode(color: SKColor.red, size: size)
        
        super.init()
        node.entity = entity
        spriteNode.entity = entity
        
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

