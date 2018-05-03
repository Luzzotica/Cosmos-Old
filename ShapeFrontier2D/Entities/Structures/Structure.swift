//
//  Structure.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Structure : GKEntity {
    
    var level : Int = 1
    
    var health_max : Int = 0
    var health_current : Int = 0
    
    var damage : Int = 0
    
    // Recursive searching variables
    static var dontLookAtID = 0
    static let dontLookAtID_max = 10000
    static var dontLookAt : [Int:[Supplier]] = [:]
    
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
    var tick_action = 1
    
    var power_lowOverlay : SKSpriteNode!
    
    // If we want to disable it, we can. This makes it unable to connect or do anything. Mostly used for the building objects
    var isDisabled = false
    
    func takeDamage(amount: Int) {
        health_current -= amount
        if health_current < 0 {
            didDied()
        }
    }
    
    func build() {
        // Current way is to add to health the powerToBuild
        health_current += power_toBuild
        
        // Once health is full, cap it, and make it done building
        if health_current >= health_max {
            health_current = health_max
            underConstruction = false
            
        }
    }
    
    
    
    func setupStructure() {
        
    }
    
    func levelup() {
        level += 1
    }
    
    func heal(amount: Int) {
        health_current += amount
        if health_current > health_max {
            health_current = health_max
        }
    }
    
    func didDied() {
        //Remove self from global structures list and individual type list
        connection_powerLine?.destroySelf()
    }
    
    func recycle() {
        gameScene.minerals_current += Int(CGFloat(constructionCost) * 0.75)
        EntityManager.shared.remove(self)
    }
    
    func tick() {
        power_handleOverlay()
    }
    
     /*
     POWERRRR FUNCTIONS
     */
    
    func power_update() {
        if power_current < power_toUse {
            let mySprite = component(ofType: SpriteComponent.self)!.spriteNode
            mySprite.addChild(power_lowOverlay)
        }
        else {
            power_lowOverlay.removeFromParent()
        }
    }
    
    static func power_prepareFind() -> Int {
        // Prepares the static variables for a new find, returns the dontLookAtID after prep
        // Get a new dontLookAtID by increasing it by one
        dontLookAtID += 1
        
        // If the dontLookAtID is greater than one, we restart at 0
        if dontLookAtID > dontLookAtID_max {
            dontLookAtID = 0
        }
        
        // Prepare the dontLookAt dictionary for that ID usage
        dontLookAt[dontLookAtID] = []
        
        return dontLookAtID
    }
    
    static func power_finishedFind(findID: Int) {
        dontLookAt[findID] = []
    }
    
    // Traces to a power source with power
    func power_find(amount: Int, distance: Int, dontLookAtID: Int) -> Int {
        // If we have energy globaly, use it
        if gameScene.player_powerCurrent >= amount {
            let distance = connection_master!.power_find(amount: amount, distance: distance + 1, dontLookAtID: dontLookAtID)
            
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
    
    func power_handleOverlay() {
        // Adds the out of power overlay if we
        // Have no master or If we are out of power
        if power_lowOverlay.parent == nil
            && (connection_master == nil
                || gameScene.player_powerCurrent < power_toUse),
            let spriteComponent = component(ofType: SpriteComponent.self) {
            spriteComponent.spriteNode.addChild(power_lowOverlay)
        }
            // Removes the power overlay if
            // We have a master, and we have power
            // Demorgans law for the win in negating the previous if statement =D
        else if power_lowOverlay.parent != nil
            && connection_master != nil
            && gameScene.player_powerCurrent >= power_toUse {
            power_lowOverlay.removeFromParent()
        }
    }
    
    /*
    CONNECTION FUNCTIONS
    */
    
    func connection_findMasters() {
//        print("Finding wrong master")
    }
    
    func connection_masterDied() {
//        print("got here")
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
            connection_master = (structure as! Supplier)
            
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
    
    func didFinishConstruction() {
        connection_findMasters()
        connection_powerLine?.constructPowerLine()
        
        power_handleOverlay()
        
        // Update the positioning of the move component, and GKGraphNode
        if let moveComponent = component(ofType: MoveComponent.self),
            let spriteComponent = component(ofType: SpriteComponent.self) {
            moveComponent.position = float2(spriteComponent.node.position)
        }
        
    }
    
    init(texture: SKTexture, size: CGSize, team: Team) {
        super.init()
        
        let spriteComponent = SpriteComponent(entity: self, texture: texture, size: size)
        spriteComponent.node.name = "entity"
        addComponent(spriteComponent)
        
        spriteComponent.node.physicsBody?.categoryBitMask = CollisionType.Structure
        spriteComponent.node.physicsBody?.contactTestBitMask = CollisionType.Structure
        spriteComponent.node.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        spriteComponent.spriteNode.zPosition = Layer.Player
        
        spriteComponent.node.name! += "_structure"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
