//
//  StructureValues.swift
//  Cosmos
//
//  Created by Sterling Long on 5/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

extension Structure {
    
    static let connection_length : CGFloat = sceneWidth * 0.225
    
    struct Size {
        static let large = CGSize(width: sceneWidth * 0.09, height: sceneWidth * 0.09)
        static let small = CGSize(width: sceneWidth * 0.05, height: sceneWidth * 0.05)
        static let node = CGSize(width: sceneWidth * 0.015, height: sceneWidth * 0.03)
    }
    
    struct MinerValues {
        static let maxHealth : [CGFloat] = [25, 30]
        static let power_toBuild : Int = 1
        static let power_toUse : Int = 5
        static let build_ticks : Int = 6
        
        static let power_toUpgrade : Int = 1
        static let upgrade_ticks : [Int] = [4]
        
        static let range : CGFloat = sceneWidth * 0.2
        static let damage : [Int] = [10, 20]
        static let damageRate : CGFloat = 1.0
        
        static let level_max : Int = 1
    }
    
    struct ReactorValues {
        static let maxHealth : [CGFloat] = [50, 60, 70]
        static let power_toBuild : Int = 2
        static let power_toUse : Int = 0
        static let build_ticks : Int = 8
        
        static let power_toUpgrade : Int = 2
        static let upgrade_ticks : [Int] = [4, 5]
        
        static let power_capacity : [Int] = [100, 120, 140]
        static let power_provided : [Int] = [5, 8, 12]
        
        static let level_max : Int = 2
    }
    
    struct NodeValues {
        static let maxHealth : CGFloat = 25
        static let power_toBuild : Int = 1
        static let power_toUse : Int = 0
        static let build_ticks : Int = 4
    }
    
    struct MissileCannonValues {
        static let maxHealth : [CGFloat] = [50, 60, 70]
        static let power_toBuild : Int = 2
        static let power_toUse : Int = 8
        static let build_ticks : Int = 7
        
        static let power_toUpgrade : Int = 2
        static let upgrade_ticks : [Int] = [4, 5]
        
        static let range : [CGFloat] = [sceneWidth * 0.8, sceneWidth * 1.0, sceneWidth * 1.2]
        static let damage : [CGFloat] = [10, 15, 20]
        static let damageRate : [CGFloat] = [1.0, 0.9, 0.8]
        
        static let level_max : Int = 2
    }
    
    struct PulseCannonValues {
        static let maxHealth : [CGFloat] = [50, 60, 70]
        static let power_toBuild : Int = 2
        static let power_toUse : Int = 4
        static let build_ticks : Int = 7
        
        static let power_toUpgrade : Int = 2
        static let upgrade_ticks : [Int] = [4, 5]
        
        static let range : [CGFloat] = [sceneWidth * 0.5, sceneWidth * 0.6, sceneWidth * 0.7]
        static let damage : [CGFloat] = [5, 7, 9]
        static let damageRate : [CGFloat] = [0.5, 0.45, 0.4]
        
        static let level_max : Int = 2
    }
}
