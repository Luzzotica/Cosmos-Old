//
//  UI_Button.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 1/30/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class UI_Button : SKNode {
    
    var node_text : SKLabelNode?
    var node_button : SKSpriteNode?
    
    func setupText(text: String, textSize: CGFloat, name: String, fontColor: UIColor) {
        // Label Node
        // Create and attach the label node
        node_text = SKLabelNode(text: text)
        node_text?.fontName = fontStyleT
        node_text?.fontSize = textSize
        node_text?.fontColor = fontColor
        //pauseText.zPosition = Layer.UI
        
        // Found with their name, make sure it is unique
        node_text?.name = name + "_child"
        
        // Center the text
        node_text?.horizontalAlignmentMode = .center
        node_text?.verticalAlignmentMode = .center
        
        node_button!.addChild(node_text!)
    }
    
    func setupButton(size: CGSize, name: String, color: UIColor) {
        // Button
        // Create and attach the colored button
        node_button = SKSpriteNode(color: color, size: size)
        
        // Found with their name, make sure it is unique
        node_button?.name = name + "_child"
        
        addChild(node_button!)
    }
    
    override init() {
        super.init()
    }
    
    convenience init(size: CGSize,
                     text: String,
                     name: String,
                     backgroundColor: UIColor = .cyan,
                     fontSize: CGFloat = fontSizeN,
                     fontColor: UIColor = .black,
                     anchor: CGPoint = CGPoint(x: 0.0, y: 0.0)) {
        self.init()
        
        self.name = "button_" + name
        
        // Setup button
        setupButton(size: size, name: self.name!, color: backgroundColor)
        
        // Anchor the button
        node_button?.position.x = (-anchor.x + 0.5) * size.width
        node_button?.position.y = (-anchor.y + 0.5) * size.height
        
        // Setup text
        setupText(text: text, textSize: fontSize, name: self.name!, fontColor: fontColor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
