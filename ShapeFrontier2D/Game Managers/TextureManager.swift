//
//  TextureManager.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

struct Asteroids {
    static let asteroid1 = SKTexture(image: #imageLiteral(resourceName: "Asteroid1"))

}

struct Structures {
    static let reactorLevel1 = SKTexture(imageNamed: "ReactorStage1")
    static let reactorLevel2 = SKTexture(imageNamed: "ReactorStage1")
    static let reactorLevel3 = SKTexture(imageNamed: "ReactorStage1")
    
    static let minerLowPower = SKTexture(imageNamed: "MinerNoPwr")
    static let miner = SKTexture(imageNamed: "MinerPwr")
    static let minerMining = SKTexture(imageNamed: "MinerMining")
    
    
    static let nodeLowPower = SKTexture(imageNamed: "NodeNoPwr")
    static let node = SKTexture(imageNamed: "NodePwr")
    static let nodePowerFlowing = SKTexture(imageNamed: "NodePwrFlowing")
    
    static let powerLineNoPower = SKTexture(imageNamed: "LineNoPwr")
    static let powerLine = SKTexture(imageNamed: "LinePwr")
    static let powerLineFlowing = SKTexture(imageNamed: "LinePwrFlowing")
    
    static let missileCannon = SKTexture(imageNamed: "HeatMissileCannon")
    
    static let pulseLaserLevel1 = SKTexture(imageNamed: "PulseLaser1")
    static let pulseLaserLevel2 = SKTexture(imageNamed: "PulseLaser2")
    static let pulseLaserLevel3 = SKTexture(imageNamed: "PulseLaser3")
    static let pulseLaser = SKTexture(imageNamed: "")
    
    static let outOfPowerOverlay = SKTexture(imageNamed: "LowPwrOverlay")
}

struct Weapons {
    // Miner "weapon"
    static let minerLaser = SKTexture(imageNamed: "MiningLaser")
    
    // Missile Cannon weapon
    static let missileCannonMissile = SKTexture(imageNamed: "HeatMissile")
}
