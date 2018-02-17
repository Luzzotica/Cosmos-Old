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
    var powerLine : SKShapeNode
    
    var toDestroy = false
    var isValidSpot = true
    
    func powerUp() {
//        let lightUp = SKAction.run {
//            self.powerLine.strokeColor = PowerLine.colorLit
//        }
        let lightUp = SKAction.colorize(with: PowerLine.colorLit, colorBlendFactor: 1.0, duration: 0.0)
        let wait = SKAction.wait(forDuration: 0.15)
//        let toNormal = SKAction.run {
//            self.powerLine.strokeColor = PowerLine.colorNormal
//        }
        let toNormal = SKAction.colorize(with: PowerLine.colorNormal, colorBlendFactor: 1.0, duration: 0.0)
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
        
        // Create the points offset to the left and right of the structures, should be the same for both buildings
//        let leftOffset = CGPoint(x: cos(angleBetweenStructures - .pi/2.0) * PowerLine.lineWidth * 0.5, y: sin(angleBetweenStructures - .pi/2.0) * PowerLine.lineWidth * 0.5)
//        let rightOffset = CGPoint(x: cos(angleBetweenStructures + .pi/2.0) * PowerLine.lineWidth * 0.5, y: sin(angleBetweenStructures + .pi/2.0) * PowerLine.lineWidth * 0.5)
        
        // Otherwise, create the physics body for later collisions
        let angleBetweenStructures = atan2(structureOne!.position.x - structureTwo!.position.x, structureOne!.position.y - structureTwo!.position.y)
        print("Angle between the two: \(angleBetweenStructures)")
        
        
        
        let size = CGSize(width: PowerLine.lineWidth, height: getDistance(point1: structureOne!.position, point2: structureTwo!.position))
        let rect = CGRect(origin: structureOne!.position, size: size)
        powerLine = SKShapeNode(rect: rect)
        powerLine.zRotation = angleBetweenStructures
        structureOne?.addChild(powerLine)
        
        powerLine.physicsBody = SKPhysicsBody(rectangleOf: size)
        powerLine.physicsBody?.categoryBitMask = CollisionType.PowerLine
        powerLine.physicsBody?.contactTestBitMask = CollisionType.Construction
    }
    
    // Checks for collisions on the line of the powerline
    func collisionCheck() {
        // It's a valid spot until proven otherwise
        isValidSpot = true
        
        // Ray cast between the structures
        // Checks all physics bodies between the two points
        gameScene.physicsWorld.enumerateBodies(alongRayStart: structureOne!.position, end: structureTwo!.position, using: {(body: SKPhysicsBody, point: CGPoint, normal: CGVector, stop: UnsafeMutablePointer<ObjCBool>) in
            if body.node != self.structureOne && body.node != self.structureTwo {
                if body.categoryBitMask != CollisionType.PowerLine {
                    // If we found an object that isn't a powerline, we stop, and say we aren't in a valid spot
                    print(body.categoryBitMask)
                    stop.pointee = true
                    self.isValidSpot = false
                    print(self.isValidSpot)
                }
            }
        })
        
        
        if !isValidSpot {
            powerLine.strokeColor = .red
        }
        else {
            powerLine.strokeColor = PowerLine.colorNormal
        }
    }
    
    func update() {
        if structureOne == nil || structureTwo == nil {
            destroySelf()
            return
        }
        
        // Searches along the powerline. Turns it red if it's invalid
        collisionCheck()
        
        if withinDistance(point1: structureOne!.position,
                          point2: structureTwo!.position,
                          distance: PowerLine.range_max).0
        {
            let path: CGMutablePath = CGMutablePath()
            path.move(to: CGPoint.zero)
            path.addLine(to: structureTwo!.position - structureOne!.position)
            
            powerLine.path = path
        }
        else {
            destroySelf()
        }
    }
    
    func destroySelf() {
        if toDestroy {
            return
        }
        print("Destroying self")
        
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
        
        // Create a path
        let path: CGMutablePath = CGMutablePath()
        
        path.move(to: CGPoint.zero)
        
        let pointOne = structureOne!.position
        let pointTwo = structureTwo!.position
        path.addLine(to: pointTwo - pointOne)
        path.addLine(to: pointOne - pointTwo)
        
        // Create a line out of it
        powerLine = SKShapeNode(path: path)
        powerLine.strokeColor = PowerLine.colorNormal
        powerLine.lineWidth = PowerLine.lineWidth
        
        // Add the line to the target structure
        structureOne?.addChild(powerLine)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
