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
    
    var fromStructure : Structure?
    var toStructure : Structure?
    var powerLine : SKShapeNode?
    
    let lineWidth = sceneWidth * 0.02
    
    var range_max : CGFloat = sceneWidth * 0.225
    
    func updateSelf() {
        if withinDistance(point1: (toStructure?.position)!,
                          point2: (fromStructure?.position)!,
                          distance: range_max)
        {
            let path: CGMutablePath = CGMutablePath()
            path.move(to: (toStructure?.position)!)
            path.addLine(to: (fromStructure?.position)!)
            
            powerLine?.path = path
        }
        else {
            destroySelf()
        }
    }
    
    func destroySelf() {
        powerLine?.removeFromParent()
        toStructure = nil
        fromStructure = nil
    }
    
    init(to: Structure, from: Structure) {
        super.init()
        
        toStructure = to
        fromStructure = from
        
        // Create a path
        let path: CGMutablePath = CGMutablePath()
        path.move(to: CGPoint.zero)
        
        let toP = (toStructure?.position)!
        let fromP = (fromStructure?.position)!
        let nextPoint = fromP - toP
        path.addLine(to: nextPoint)
        
        // Create a line out of it
        powerLine = SKShapeNode(path: path)
        powerLine?.strokeColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        
        // Add the line to the target structure
        toStructure?.addChild(powerLine!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
