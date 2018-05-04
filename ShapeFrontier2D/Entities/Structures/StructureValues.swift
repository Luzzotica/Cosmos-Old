//
//  StructureValues.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 5/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

struct MinerValues {
    static let maxHealth : CGFloat = 25
    static let power_toBuild : Int = 1
    static let power_toUse : Int = 5
    
    static let range : CGFloat = sceneWidth * 0.2
    static let damage : CGFloat = 10
    static let damageRate : CGFloat = 1.0
}

struct ReactorValues {
    static let maxHealth : CGFloat = 50
    static let power_toBuild : Int = 2
    static let power_toUse : Int = 0
    
    static let power_capacity : Int = 100
    static let power_provided : Int = 5
}

struct NodeValues {
    static let maxHealth : CGFloat = 25
    static let power_toBuild : Int = 1
    static let power_toUse : Int = 0
}

struct MissileCannonValues {
    static let maxHealth : CGFloat = 50
    static let power_toBuild : Int = 2
    static let power_toUse : Int = 8
    
    static let range : CGFloat = sceneWidth * 0.8
    static let damage : CGFloat = 10
    static let damageRate : CGFloat = 1.0
}

struct PulseCannonValues {
    static let maxHealth : CGFloat = 50
    static let power_toBuild : Int = 2
    static let power_toUse : Int = 4
    
    static let range : CGFloat = sceneWidth * 0.5
    static let damage : CGFloat = 5
    static let damageRate : CGFloat = 0.5
}