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
    
    var structureOne : Structure?
    var structureTwo : Structure?
    var powerLine : SKShapeNode?
    
    let lineWidth = sceneWidth * 0.01
    
    var range_max : CGFloat = sceneWidth * 0.225
    
    var toDestroy = false
    
    func powerUp() {
//        let lightUp = SKAction.colorize(with: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), colorBlendFactor: 1.0, duration: 0.2)
//        let toNormal = SKAction.colorize(with: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), colorBlendFactor: 1.0, duration: 0.2)
//        let sequence = SKAction.sequence([lightUp, toNormal])
//        powerLine?.run(sequence)
        let lightUp = SKAction.run {
            self.powerLine?.strokeColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }
        let wait = SKAction.wait(forDuration: 0.15)
        let toNormal = SKAction.run {
            self.powerLine?.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
        let sequence = SKAction.sequence([lightUp, wait, toNormal])
        powerLine?.run(sequence)
        
    }
    
    func update() {
        if structureOne == nil || structureTwo == nil {
            destroySelf()
            return
        }
        
        if withinDistance(point1: structureOne!.position,
                          point2: structureTwo!.position,
                          distance: range_max).0
        {
            let path: CGMutablePath = CGMutablePath()
            path.move(to: CGPoint.zero)
            path.addLine(to: structureTwo!.position - structureOne!.position)
            
            powerLine?.path = path
        }
        else {
            destroySelf()
        }
    }
    
    func destroySelf() {
        // Remove themselves from the connected lists
        if structureOne != nil && structureTwo != nil {
            if structureTwo!.isSupplier {
                let supplierTwo = structureTwo as! Supplier
                let _ = supplierTwo.connection_remove(toRemove: structureOne!)
            }
            else {
                structureTwo?.connection_master = nil
            }
            
            if structureOne!.isSupplier {
                let supplierOne = structureOne as! Supplier
                let _ = supplierOne.connection_remove(toRemove: structureTwo!)
            }
            else {
                structureOne?.connection_master = nil
            }
        }
        
        powerLine?.removeFromParent()
        toDestroy = true
        structureTwo = nil
        structureOne = nil
    }
    
    init(structOne: Structure, structTwo: Structure) {
        super.init()
        
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
        powerLine?.strokeColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        powerLine?.lineWidth = lineWidth
        
       // powerLine?.physicsBody = SKPhysicsBody(
        powerLine?.physicsBody?.categoryBitMask = CollisionType.PowerLine
        powerLine?.physicsBody?.contactTestBitMask = CollisionType.Construction
        
        // Add the line to the target structure
        structureOne?.addChild(powerLine!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
