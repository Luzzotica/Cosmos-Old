//
//  EntityTypeComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 3/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

enum Type: Int {
    case structure, missile, ship, asteroid
}

class EntityTypeComponent : GKComponent {
    
    let entityType : Type
    
    init(type: Type) {
        entityType = type
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
