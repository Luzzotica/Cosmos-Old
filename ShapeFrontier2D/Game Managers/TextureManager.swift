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
    static let reactorLevel2 = SKTexture(imageNamed: "ReactorStage2")
    static let reactorLevel3 = SKTexture(imageNamed: "ReactorStage3")
    
    static let minerLowPower = SKTexture(imageNamed: "MinerNoPwr")
    static let miner = SKTexture(imageNamed: "MinerPwr")
    static let minerMining = SKTexture(imageNamed: "MinerMining")
    
    
    static let nodeLowPower = SKTexture(imageNamed: "NodeNoPwr")
    static let node = SKTexture(imageNamed: "NodePwr")
    static let nodePowerFlowing = SKTexture(imageNamed: "NodePwrFlowing")
    
    static let powerLineNoPower = SKTexture(imageNamed: "LineNoPwr")
    static let powerLine = SKTexture(imageNamed: "LinePwr")
    static let powerLineFlowing = SKTexture(imageNamed: "LinePwrFlowing")
    
    static let missileCannonLevel1 = SKTexture(imageNamed: "HeatMissileCannon1")
    static let missileCannonLevel2 = SKTexture(imageNamed: "HeatMissileCannon2")
    static let missileCannonLevel3 = SKTexture(imageNamed: "HeatMissileCannon3")
    
    static let pulseLaser = SKTexture(imageNamed: "Pulser")
    static let pulseLevel1 = SKTexture(imageNamed: "PulseLevel1")
    static let pulseLevel2 = SKTexture(imageNamed: "PulseLevel2")
    static let thuleLevel1 = SKTexture(imageNamed: "ThuleLevel1")
    static let thuleLevel2 = SKTexture(imageNamed: "ThuleLevel2")
    
    static let outOfPowerOverlay = SKTexture(imageNamed: "LowPwrOverlay")
}

struct Weapons {
    // Miner "weapon"
    static let minerLaser = SKTexture(imageNamed: "MiningLaser")
    
    // Missile Cannon weapon
    static let missileCannonMissile = SKTexture(imageNamed: "HeatMissile")
    
    static let pulseLaser = SKTexture(imageNamed: "PulseLaser")
    static let thuleLaser1 = SKTexture(imageNamed: "ThuleLaser1")
    static let thuleLaser2 = SKTexture(imageNamed: "ThuleLaser2")
}

struct Area {
    static let area = SKTexture(imageNamed: "ConnectRange")
}
