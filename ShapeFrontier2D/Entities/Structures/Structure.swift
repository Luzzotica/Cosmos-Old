//
//  Structure.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Structure : Entity {
    
    var level : Int = 1
    
    var isBuilding = true
    
    // higher the number the higher the priority
    var powerPriority : Int!
    var powerToBuild : Int!
    var powerToUse : Int!
    var powerCurrent : Int!
    var lowPower = false
    
    var lowPowerOverlay : SKSpriteNode!
    
    func build() {
        // Current way is to add to health the powerToBuild
        health += powerToBuild
        
        // Once health is full, cap it, and make it done building
        if health >= health_max {
            health = health_max
            isBuilding = false
            
        }
    }
    
    func power_update() {
        if powerCurrent < powerToUse {
            self.addChild(lowPowerOverlay)
        }
        else {
            lowPowerOverlay.removeFromParent()
        }
    }
    
    func power_use() {
        
    }
    
    func setupStructure() {
        
    }
    
    func levelup() {
        level += 1
    }
    
    func heal(amount: Int) {
        health += amount
        if health > health_max {
            health = health_max
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
