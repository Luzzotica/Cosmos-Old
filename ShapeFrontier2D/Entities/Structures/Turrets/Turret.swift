//
//  Turret.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class Turret : Structure {
    
    var range : CGFloat = 0.0
    
    override func select() {
        // Create a range indicator for ourselves
        let indicatorRange = UIHandler.shared.createRangeIndicator(range: range, color: .red)
        
        // Get the sprite component
        let spriteComponent = component(ofType: SpriteComponent.self)
        spriteComponent!.select(toAdd: [indicatorRange])
    }
    
    override init(texture: SKTexture, size: CGSize, team: Team) {
        super.init(texture: texture, size: size, team: team)
        
        let spriteComponent = component(ofType: SpriteComponent.self)
        
        spriteComponent!.node.name! += "_turret"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
