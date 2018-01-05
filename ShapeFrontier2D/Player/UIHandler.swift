//
//  UICreator_PauseGame.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 1/1/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class UIHandler : NSObject {
    
    static let shared = UIHandler()
	private override init() {}
    
    func createPauseGameUI() -> SKNode {
        let pauseLabel = SKLabelNode(text: "Game Paused!")
        pauseLabel.fontName = fontStyleT
        pauseLabel.fontSize = fontSizeT
        pauseLabel.name = "lostLabel"
        pauseLabel.verticalAlignmentMode = .center
        pauseLabel.horizontalAlignmentMode = .center
        
        pauseLabel.position = CGPoint(x: sceneWidth * 0.5, y: sceneHeight * 0.66)
        pauseLabel.zPosition = Layer.UI
        
        let pauseText = SKLabelNode(text: "Type any letter to continue!")
        pauseText.fontName = fontStyleN
        pauseText.fontSize = fontSizeN
        pauseText.name = "lostText"
        pauseText.verticalAlignmentMode = .center
        pauseText.horizontalAlignmentMode = .center
        
        pauseText.position = CGPoint(x: sceneWidth * 0.5, y: sceneHeight * 0.58)
        pauseText.zPosition = Layer.UI
        
        // Create the restart button
        let restartButtonSize = CGSize(width: sceneWidth * 0.24, height: sceneHeight * 0.15)
        let restartButton = UIHandler.shared.createButton(name: "button_restart", size: restartButtonSize, text: "Restart", backgroundColor: .cyan)
        restartButton.position.x = sceneWidth * 0.5
        restartButton.position.y = sceneHeight * 0.40
        restartButton.zPosition = Layer.UI
        
        // setup the return node
        let pauseNode = SKNode()
        pauseNode.name = "UIBlock"
        
        pauseNode.addChild(createBackgroundDarkening())
        pauseNode.addChild(pauseLabel)
        pauseNode.addChild(pauseText)
        pauseNode.addChild(restartButton)
        
        return pauseNode
    }
    
    func createLostGameUI() -> SKNode {
        let lostLabel = SKLabelNode(text: "YOU WERE CAPTURED!")
        lostLabel.fontName = fontStyleT
        lostLabel.fontSize = fontSizeT
        lostLabel.name = "lostLabel"
        lostLabel.verticalAlignmentMode = .center
        lostLabel.horizontalAlignmentMode = .center
        
        lostLabel.position = CGPoint(x: sceneWidth * 0.5, y: sceneHeight * 0.54)
        lostLabel.zPosition = Layer.UI
        
        let lostText = SKLabelNode(text: "Type any letter to play again!")
        lostText.fontName = fontStyleN
        lostText.fontSize = fontSizeN
        lostText.name = "lostText"
        lostText.verticalAlignmentMode = .center
        lostText.horizontalAlignmentMode = .center
        
        lostText.position = CGPoint(x: sceneWidth * 0.5, y: sceneHeight * 0.46)
        lostText.zPosition = Layer.UI
        
        // setup the return node
        let node = SKNode()
        node.name = "UIBlock"
        
        node.addChild(createBackgroundDarkening())
        node.addChild(lostLabel)
        node.addChild(lostText)
        
        return node
    }
    
    func createButton(name: String,
                      size: CGSize,
                      text: String,
                      backgroundColor: UIColor,
                      fontColor: UIColor = .black) -> SKNode {
        // Label Node
        // Create and attach the label node
        let pauseText = SKLabelNode(text: text)
        pauseText.fontName = fontStyleT
        pauseText.fontSize = fontSizeT
        pauseText.fontColor = fontColor
        pauseText.zPosition = Layer.UI
        
        // Found with their name, make sure it is unique
        pauseText.name = name
        
        // Center the text
        pauseText.horizontalAlignmentMode = .center
        pauseText.verticalAlignmentMode = .center
        
        // Button Background
        // Create and attach the colored background
        let pauseButton = SKSpriteNode(color: backgroundColor, size: size)
        //pauseButton.alpha = 0.3
        
        // Found with their name, make sure it is unique
        pauseButton.name = name
        
        // move to top of left HUD
        pauseButton.zPosition = Layer.UI
        
        // Creat the node and add its children
        let buttonNode = SKNode()
        buttonNode.name = name
        buttonNode.zPosition = Layer.UI
        
        buttonNode.addChild(pauseButton)
        buttonNode.addChild(pauseText)
        
        // You need to set his position yourself
        return buttonNode
    }
    
    func createBackgroundDarkening() -> SKSpriteNode {
        let coverSize = CGSize(width: sceneWidth, height: sceneHeight)
        let darkening = SKSpriteNode(color: .black, size: coverSize)
        
        darkening.name = "screenDarkening"
        
        darkening.anchorPoint.x = 0.0
        darkening.anchorPoint.y = 0.0
        darkening.zPosition = Layer.UI
        
        // Make it see through
        darkening.alpha = 0.4
        
        return darkening
    }
    
    func destroyUI() {
        for node in gameScene.children {
            if node.name == "UIBlock" {
                node.removeFromParent()
                return
            }
        }
    }
    
}
