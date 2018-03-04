//
//  PlayerHUDExt_StructureInfo.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 2/19/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

class InfoViewNode : SKNode {
    
    // Structure image
    var structureImage : SKSpriteNode!
    var structureImageTwo : SKSpriteNode!
    
    // Info View
    var infoView = SKNode()
    var infoViewWidth: CGFloat = sceneWidth * 0.25
    
    var healthLabel : SKLabelNode!
    var damageLabel : SKLabelNode!
    var upgradeButton : UI_Button!
    var destroyButton : UI_Button!
    var upgradeBar : SKSpriteNode!
    
    var currentEntity : GKEntity!
    var currentSprite : SKSpriteNode!
    
    let colorGreen = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.2)
    let colorNormal = SKAction.colorize(with: .green , colorBlendFactor: 0.0, duration: 0.2)
    
    func deselectEntity() {
        if currentEntity != nil {
            
            currentSprite.removeAllActions()
            currentSprite.run(colorNormal)
        }
    }
    
    func displayInfo(entity: GKEntity) {
        // If there was a node before we tapped, then we should color him back to normal...
        deselectEntity()
        
        // Set the new entity!
        currentEntity = entity
        currentSprite = currentEntity.component(ofType: SpriteComponent.self)?.node
        
        // Show or hide buttons depending on the type of the the entity we tapped on
        if !(currentEntity is Structure)
        {
            destroyButton.isHidden = true
            upgradeButton.isHidden = true
        }
        else
        {
            destroyButton.isHidden = false
            upgradeButton.isHidden = false
        }
        
        // Set the structure display image to our currentSprite image
        structureImage.texture = currentSprite.texture
        
        // Color the entity so we know who we are looking at
        currentSprite.removeAllActions()
        currentSprite.run(colorGreen)
        
        // Update the info, this is called every frame
        updateInfo()
    }
    
    func updateInfo() {
        
        
//        healthLabel.text = "Health: \(currentEntity.health_current)/\(currentEntity.health_max)"
//        if currentEntity.damage != 0 {
//            damageLabel.text = "Damage: \(currentEntity.damage)"
//        }
//        else {
//            damageLabel.text = "Damage: N/A"
//        }
//        
//        if currentEntity is Structure {
////            healthLabel.text = (currentEntity as! Structure).connection_master?.name
//        }
//        
//        if currentEntity is Supplier {
//            healthLabel.text = "Master Count: \((currentEntity as! Supplier).connection_masters.count), Conn Count: \((currentEntity as! Supplier).connection_toStructures.count)"
//        }
//        
//        if currentEntity is Asteroid {
//            healthLabel.text = "Minerals: \(currentEntity.health_current)/\(currentEntity.health_max)"
//            // If our currentEntity has no child, and he is an asteroid
//            let gas = currentSprite.children[0] as! SKSpriteNode
//            structureImageTwo.texture = gas.texture
//            
//            structureImageTwo.alpha = CGFloat(currentEntity.health_current) / CGFloat(currentEntity.health_max)
//        }
//        else if currentEntity is Miner {
//            damageLabel.text = "Mining POWERRRR!: \(currentEntity.damage)"
//        }
//        else {
//            structureImageTwo.texture = nil
//        }
        
        
    }
    
    func destroySelectedStructure()
    {
        (currentEntity as! Structure).recycle()
        
    }
    
    init(bottomBar_height: CGFloat, bottomBar_buffer: CGFloat) {
        super.init()
        
        // Anchor this node at the bottom right of the screen
        position.x = sceneWidth * -0.5
        position.y = 0.0
        
        // Setup the image
        let iconSize = CGSize(width: bottomBar_height, height: bottomBar_height)
        let buffer : CGFloat = bottomBar_buffer * 0.5
        
        structureImage = SKSpriteNode(color: .black, size: iconSize)
        structureImage.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        structureImage.position = CGPoint(x: buffer, y: buffer)
        structureImage.zPosition = 2
        
        structureImageTwo = SKSpriteNode(color: .clear, size: iconSize)
        structureImageTwo.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        structureImageTwo.position = CGPoint(x: buffer, y: buffer)
        structureImageTwo.zPosition = 1
        
        // Shift infoView node over
        infoView.position.x = iconSize.width + bottomBar_buffer
        infoViewWidth = sceneWidth * 0.7 - bottomBar_height - bottomBar_buffer
        
        // Setup the Health Label
        var yPosition = bottomBar_height + bottomBar_buffer * 0.5
        healthLabel = SKLabelNode(text: "Structure Health")
        healthLabel.position.y = yPosition
        healthLabel.zPosition = 1
        
        healthLabel.fontName = fontStyleN
        healthLabel.fontSize = fontSizeS
        
        healthLabel.horizontalAlignmentMode = .left
        healthLabel.verticalAlignmentMode = .top
        
        // Setup the damage label
        yPosition -= fontSizeS * 1.2
        damageLabel = SKLabelNode(text: "Structure Damage")
        damageLabel.position.y = yPosition
        damageLabel.zPosition = 1
        
        damageLabel.fontName = fontStyleN
        damageLabel.fontSize = fontSizeS
        
        damageLabel.horizontalAlignmentMode = .left
        damageLabel.verticalAlignmentMode = .top
        
        // Setup upgrade button
        let buttonSize = CGSize(width: infoViewWidth * 0.4, height: bottomBar_height * 0.45)
        
        yPosition = bottomBar_height + bottomBar_buffer * 0.5
        upgradeButton = UI_Button(size: buttonSize,
                                  text: "Upgrade",
                                  name: "upgrade",
                                  backgroundColor: .green,
                                  fontSize: fontSizeS,
                                  anchor: CGPoint(x: 1.0, y: 1.0))
        upgradeButton.position.x = infoViewWidth - bottomBar_buffer * 0.5
        upgradeButton.position.y = yPosition
        upgradeButton.zPosition = 1
        
        // Setup destroy button
        yPosition -= buttonSize.height + bottomBar_height * 0.1
        destroyButton = UI_Button(size: buttonSize,
                                  text: "Destroy",
                                  name: "destroy",
                                  backgroundColor: .red,
                                  fontSize: fontSizeS,
                                  anchor: CGPoint(x: 1.0, y: 1.0))
        destroyButton.position.x = infoViewWidth - bottomBar_buffer * 0.5
        destroyButton.position.y = yPosition
        destroyButton.zPosition = 1
        
        // Add all the things as children
        addChild(structureImage)
        addChild(structureImageTwo)
        
        addChild(infoView)
        
        infoView.addChild(healthLabel)
        infoView.addChild(damageLabel)
        infoView.addChild(upgradeButton)
        infoView.addChild(destroyButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
