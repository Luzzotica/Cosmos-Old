//
//  Supplier.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Supplier : Structure {
    
    var connection_toStructures : [Structure] = []
    
    func drawPower(amount: Int) {
        
    }
    
    func alreadyConnected(toCheck: Structure) -> Bool {
        for structure in connection_toStructures {
            if toCheck.isEqual(structure) {
                return true
            }
        }
        return false
    }
    
    func connection_addTo(structure: Structure) {
        if !alreadyConnected(toCheck: structure) {
            connection_toStructures.append(structure)
            connection_powerLine.append(PowerLine(structOne: self, structTwo: structure))
        }
        
    }
    
    func connection_updateLines() {
        for i in stride(from: connection_powerLine.count - 1, through: 0, by: -1) {
            if connection_powerLine[i].toDestroy {
                connection_powerLine.remove(at: i)
            }
            else {
                connection_powerLine[i].update()
            }
        }
    }
    
    func connection_remove(toRemove: Structure) -> Bool {
        for i in 0..<connection_toStructures.count {
            if connection_toStructures[i].isEqual(toRemove) {
                connection_toStructures.remove(at: i)
                return true
            }
        }
        return false
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        isSupplier = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
