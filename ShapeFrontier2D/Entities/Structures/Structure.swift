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
    
    // Construction variables
    var constructionCost = 0
    var underConstruction = true
    
    // Clustering variables
    var isRootNode : Bool = false
    var rootNode : Structure?
    
    // Connection variables
    var connection_master : Supplier?
    var connection_powerLine : PowerLine?
    
    // Power variables
    var power_priority : Int = 0
    var power_toBuild : Int = 0
    var power_toUse : Int = 0
    var power_current : Int = 0
    
    var isSupplier = false
    
    // Tick variables
    var tick_count = 0
    var tick_action = 5
    
    var lowPowerOverlay : SKSpriteNode!
    
    // If we want to disable it, we can. This make it unable to connect or do anything. Mostly used for the building objects
    var isDisabled = false
    
    func build() {
        // Current way is to add to health the powerToBuild
        health += power_toBuild
        
        // Once health is full, cap it, and make it done building
        if health >= health_max {
            health = health_max
            underConstruction = false
            
        }
    }
    
    func power_update() {
        if power_current < power_toUse {
            self.addChild(lowPowerOverlay)
        }
        else {
            lowPowerOverlay.removeFromParent()
        }
    }
    
    // Traces to a power source with power
    func power_use(amount: Int, distance: Int) -> Int {
        // If we have energy globaly, use it
        if PlayerHUDHandler.shared.energy_current() >= amount {
            let distance = connection_master!.power_use(amount: amount, distance: distance + 1)
            
            // If the distance wasn't negative 1, then we light up our powerline to out master!
            if distance != -1 {
                connection_powerLine?.powerUp()
            }
            
            return distance
        }
            // If we have no energy, overlay the out of power
        else {
            
            return -1
        }
        
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
    
    func tick(_ currentTime: TimeInterval) {
//        print("Got to structure tick")
    }
    
    func connection_findMasters() {
        
    }
    
    func connection_masterDied() {
        print("got here")
        connection_master = nil
        connection_powerLine = nil
    }
    
    func alreadyConnected(toCheck: Structure) -> Bool {
        if connection_master == nil {
            return false
        }
        if toCheck.isEqual(connection_master!) {
            return true
        }
        return false
    }
    
    func connection_addTo(structure: Structure) {
        // For non supplier structures...
        // If the passed structure is not equal to current master, update it. The construction manager only passes the closest structure
        if connection_master != structure {
            
            // Connect to the new supplier
            connection_master = structure as! Supplier
            print(connection_master?.name)
            
            // If we have a connection already, destroy it.
            if connection_powerLine != nil {
                connection_powerLine?.destroySelf()
                connection_powerLine = nil
            }
            
            // Create the new power line
            connection_powerLine = PowerLine(structOne: self, structTwo: structure)
        }
    }
    
    func connection_updateLines() {
        // If our master/powerline isn't nil
        if connection_powerLine != nil {
            // We check if the powerline wants to be destroyed
            if connection_powerLine!.toDestroy {
                connection_powerLine = nil
            }
                // Otherwise we update it. This checks if the range is too long
            else {
                connection_powerLine?.update()
            }
        }
    }
    
    func connection_didFinishConstruction() {
        connection_powerLine?.constructPowerLine()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.5)
        physicsBody?.categoryBitMask = CollisionType.Structure
        physicsBody?.contactTestBitMask = CollisionType.Structure
        physicsBody?.collisionBitMask = CollisionType.Nothing
        
        zPosition = Layer.Player
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
