//
//  PowerLine.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PowerLine : NSObject {
    
    static let colorLit = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    static let colorNormal = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    
    static let lineWidth = sceneWidth * 0.01
    static let range_max : CGFloat = sceneWidth * 0.225
    
    var structureOne : Structure?
    var structureTwo : Structure?
    var powerLine : SKSpriteNode
    
    var toDestroy = false
    var isValidSpot = true
    
    func powerUp() {
//        let lightUp = SKAction.run {
//            self.powerLine.strokeColor = PowerLine.colorLit
//        }
        powerLine.removeAllActions()
        let lightUp = SKAction.colorize(with: PowerLine.colorLit, colorBlendFactor: 1.0, duration: 0.05)
        let wait = SKAction.wait(forDuration: 0.15)
//        let toNormal = SKAction.run {
//            self.powerLine.strokeColor = PowerLine.colorNormal
//        }
        let toNormal = SKAction.colorize(with: PowerLine.colorNormal, colorBlendFactor: 1.0, duration: 0.1)
        let sequence = SKAction.sequence([lightUp, wait, toNormal])
        powerLine.run(sequence)
    }
    
    // Creates the powerline's physics body so people can't build on top of it
    func constructPowerLine() {
        // If it isn't valid spot, destroy it
        if !isValidSpot {
            destroySelf()
            return
        }
        
        powerLine.physicsBody?.categoryBitMask = CollisionType.PowerLine
        
        // If we are a non-supplier structure, then we make sure whoever we just connected to knows we are here
        if !structureTwo!.isSupplier && structureOne!.isSupplier {
            print("Added structure to my list")
            let supplier = structureOne as! Supplier
            supplier.connection_toStructures.append((structureTwo!, self))
        }
        else if !structureOne!.isSupplier && structureTwo!.isSupplier {
            print("Added structure to my list")
            let supplier = structureTwo as! Supplier
            supplier.connection_toStructures.append((structureOne!, self))
        }
    }
    
    // Checks for collisions on the line of the powerline
    func collisionCheck() {
        if powerLine.physicsBody!.allContactedBodies().count > 1 {
            isValidSpot = false
        }
        else {
            isValidSpot = true
        }
        
        if !isValidSpot {
            powerLine.color = .red
        }
        else {
            powerLine.color = PowerLine.colorNormal
        }
    }
    
    func update() {
        if structureOne == nil || structureTwo == nil {
            destroySelf()
            return
        }
        
        if withinDistance(point1: structureOne!.position,
                          point2: structureTwo!.position,
                          distance: PowerLine.range_max).0
        {
            // update the size of the power line
            let newSize = CGSize(width: PowerLine.lineWidth, height: getDistance(point1: structureOne!.position, point2: structureTwo!.position))
            let updateSize = SKAction.scale(to: newSize, duration: 0.0)
            powerLine.run(updateSize)
            
            // Rotate powerline
            let angleBetweenStructures = atan2(structureOne!.position.x - structureTwo!.position.x, structureTwo!.position.y - structureOne!.position.y)
            powerLine.zRotation = angleBetweenStructures
            
            collisionCheck()
        }
        else {
            destroySelf()
        }
    }
    
    func destroySelf() {
        if toDestroy {
            return
        }
        //print("Destroy self")
        
        // Remove themselves from the connected lists
        if structureOne != nil && structureTwo != nil {
            if structureTwo!.isSupplier {
                let supplierTwo = structureTwo as! Supplier
                let _ = supplierTwo.connection_remove(toRemove: structureOne!)
            }
            else {
                if structureTwo?.connection_master == structureOne {
                    structureTwo?.connection_masterDied()
                }
            }
            
            if structureOne!.isSupplier {
                let supplierOne = structureOne as! Supplier
                let _ = supplierOne.connection_remove(toRemove: structureTwo!)
            }
            else {
                if structureOne?.connection_master == structureTwo {
                    structureOne?.connection_masterDied()
                }
            }
        }
        
        powerLine.removeFromParent()
        toDestroy = true
        structureTwo = nil
        structureOne = nil
    }
    
    init(structOne: Structure, structTwo: Structure) {
        structureOne = structOne
        structureTwo = structTwo
        
        // Set his size to the linewidth and the distance between the two structures
        let size = CGSize(width: PowerLine.lineWidth, height: getDistance(point1: structureOne!.position, point2: structureTwo!.position))
        
        // Create the powerline based on the size and correct color
        powerLine = SKSpriteNode(color: PowerLine.colorNormal, size: size)
        
        // Rotate him to the proper angle
        let angleBetweenStructures = atan2(structureOne!.position.x - structureTwo!.position.x, structureTwo!.position.y - structureOne!.position.y)
        powerLine.zRotation = angleBetweenStructures
        
        // Set its anchor point to 0.0 so it is centered on structure one
        powerLine.anchorPoint.y = 0.0
        
        let bodyCenter = CGPoint(x: 0.0, y: size.height * 0.5)
        powerLine.physicsBody = SKPhysicsBody(rectangleOf: size, center: bodyCenter)
        powerLine.physicsBody?.categoryBitMask = CollisionType.Construction
        powerLine.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.Asteroid
        powerLine.physicsBody?.collisionBitMask = CollisionType.Nothing
        
        // Add the line to the target structure
        structureOne?.addChild(powerLine)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
