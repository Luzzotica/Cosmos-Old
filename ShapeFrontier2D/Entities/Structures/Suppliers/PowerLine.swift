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
    
    func update() {
        if structureOne == nil || structureTwo == nil {
            destroySelf()
            return
        }
        
        if withinDistance(point1: structureOne!.position,
                          point2: structureTwo!.position,
                          distance: range_max)
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
        
        // Create a line out of it
        powerLine = SKShapeNode(path: path)
        powerLine?.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        powerLine?.lineWidth = lineWidth
        
        // Add the line to the target structure
        structureOne?.addChild(powerLine!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
