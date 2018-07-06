//
//  Supplier.swift
//  Cosmos
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Supplier : Structure {
    
    // MARK: - Lifetime Functions
    
    
    
    override func didDied() {
        
        //Break all connections with everybody, turrets will lose masters
//        print(connection_toStructures.count)
        for i in stride(from: connection_toStructures.count - 1, through: 0, by: -1)
        {
            connection_toStructures[i].1.destroySelf()
        }
        
        // If we were a master
        if connection_masters.count > 1 || self is Reactor
        {
            // Tell all masters that I died
            for master in connection_masters
            {
                master.0.connection_masterDied(master: self)
            }
            
            // Make them check themselves if they are still masters
            for master in connection_masters
            {
                master.0.connection_masterLost(master: self)
            }
        }
        
        connection_masters.removeAll()
    }
    
    override init(texture: SKTexture, size: CGSize, playerID: Int) {
        super.init(texture: texture, size: size, playerID: playerID)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        isSupplier = true
        
        spriteComponent!.node.name! += "_supplier"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
