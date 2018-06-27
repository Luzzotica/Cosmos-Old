//
//  UI_Button.swift
//  Cosmos
//
//  Created by Sterling Long on 1/30/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class UI_Button : SKNode {
    
    var isDisabled = false
    
    var size : CGSize!
    
    var node_text : SKLabelNode?
    
    var node_button : SKSpriteNode?
    var node_buttonColor : UIColor?
    
    var functionToRun: (() -> Void)?
    
    func setDisabled(disabled: Bool) {
        isDisabled = disabled
        
        if isDisabled {
            node_button?.color = .gray
        }
        else {
            node_button?.color = node_buttonColor!
        }
    }
    
    func setListener(function: @escaping () -> Void) {
        functionToRun = function
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // If we are disabled, stop
        if isDisabled {
            return
        }
        
        if functionToRun != nil {
            functionToRun!()
        }
    }
    
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
        node_buttonColor = color
        
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
        
        // Save our size
        self.size = size
        
        // Enable user interaction
        self.isUserInteractionEnabled = true
        
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
