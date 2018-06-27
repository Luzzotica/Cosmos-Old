//
//  UI_SliderButton.swift
//  Cosmos
//
//  Created by Sterling Long on 1/23/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class UI_SliderButton : SKNode {
    
    var node_text : SKLabelNode?
    var node_button : SKSpriteNode?
    var node_background : SKSpriteNode?
    
    var onOff = -1
    var offset : CGFloat?
    
    func slide() -> Bool {
        onOff *= -1
        
        var returnValue = false
        var color = UIColor.darkGray
        if onOff == 1 {
            returnValue = true
            color = UIColor.green
        }
        
        // Move him to opposite side
        //print(CGFloat(onOff))
        let animateLeftRight = SKAction.moveTo(x: offset! * CGFloat(onOff), duration: 0.5)
        node_button?.removeAllActions()
        node_button?.run(animateLeftRight)
        
        // Change the color
        let colorChange = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.5)
        node_background?.removeAllActions()
        node_background?.run(colorChange)
        
        return returnValue
    }
    
    func setupText(text: String, name: String, fontColor: UIColor) {
        node_text = SKLabelNode(text: text)
        node_text?.fontName = fontStyleT
        node_text?.fontSize = fontSizeN
        node_text?.fontColor = fontColor
        
        // Center the text
        node_text?.horizontalAlignmentMode = .center
        node_text?.verticalAlignmentMode = .center
        
        node_text?.name = name + "_child"
        
        addChild(node_text!)
    }
    
    func setupButton(size: CGSize, name: String, texture: SKTexture? = nil, color: UIColor) {
        if texture == nil {
            node_button = SKSpriteNode(color: color, size: size)
        }
        else {
            
        }
        //node_button?.name = "UI_background_child"
        
        // Offset him
        offset = size.width * 0.70
        node_button?.position.x = offset! * CGFloat(onOff)
        
        // Attach him to his background
        node_background?.addChild(node_button!)
    }
    
    func setupBackground(size: CGSize,  name: String, texture: SKTexture? = nil) {
        var color = UIColor.darkGray
        if onOff == 1 {
            color = UIColor.green
        }
        
        if texture == nil {
            node_background = SKSpriteNode(color: color, size: size)
        }
        else {
            
        }
        node_background?.name = name + "_child"
        
        // Move him down
        node_background?.position.y = -size.height * 0.8
        
        addChild(node_background!)
    }
    
    override init() {
        super.init()
        
    }
    
    convenience init(size: CGSize,
                     text: String,
                     name: String,
                     backgroundColor: UIColor = .cyan,
                     fontColor: UIColor = .black,
                     onOff: Int = -1) {
        self.init()
        
        self.name = "slider_" + name
        
        // If they passed a value, set it to that value
        self.onOff = onOff
        
        
        // Setup the background
        setupBackground(size: size, name: self.name!)
        
        // Setup button
        let sliderSize = CGSize(width: size.width * 0.4, height: size.height * 0.9)
        setupButton(size: sliderSize, name: self.name!, color: backgroundColor)
        
        // Setup text
        setupText(text: text, name: self.name!, fontColor: fontColor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
