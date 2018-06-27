//
//  TextureManager.swift
//  Cosmos
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

struct Enemies {
    static let fighter = SKTexture(image: #imageLiteral(resourceName: "Fighter"))
}

struct Asteroids {
    static let asteroids = [SKTexture(image: #imageLiteral(resourceName: "Asteroid1")), SKTexture(image: #imageLiteral(resourceName: "Asteroid2")), SKTexture(image: #imageLiteral(resourceName: "Asteroid3")), SKTexture(image: #imageLiteral(resourceName: "Asteroid4"))]
    static let asteroidGas = [SKTexture(image: #imageLiteral(resourceName: "AsteroidGas1")), SKTexture(image: #imageLiteral(resourceName: "AsteroidGas2")), SKTexture(image: #imageLiteral(resourceName: "AsteroidGas3")), SKTexture(image: #imageLiteral(resourceName: "AsteroidGas4"))]
}

extension Structure {
    struct Textures {
        static let reactor = [SKTexture(imageNamed: "ReactorStage1"),
                                    SKTexture(imageNamed: "ReactorStage2"),
                                    SKTexture(imageNamed: "ReactorStage3")]
        static let reactorLowPower = SKTexture(imageNamed: "DotSmallNoPwr")
        
        static let minerLowPower = SKTexture(imageNamed: "MinerNoPwr")
        static let miner = SKTexture(imageNamed: "MinerPwr")
        static let minerMining = SKTexture(imageNamed: "MinerMining")
        
        static let nodeLowPower = SKTexture(imageNamed: "NodeNoPwr")
        static let node = SKTexture(imageNamed: "NodePwr")
        static let nodePowerFlowing = SKTexture(imageNamed: "NodePwrFlowing")
        
        static let powerLineNoPower = SKTexture(imageNamed: "LineNoPwr")
        static let powerLine = SKTexture(imageNamed: "LinePwr")
        static let powerLineFlowing = SKTexture(imageNamed: "LinePwrFlowing")
        
        static let missileCannon = [SKTexture(imageNamed: "HeatMissileCannon1"),
                                    SKTexture(imageNamed: "HeatMissileCannon2"),
                                    SKTexture(imageNamed: "HeatMissileCannon3")]
        
        static let pulseLaser = [SKTexture(imageNamed: "Pulser"),
                                 SKTexture(imageNamed: "PulseLevel1"),
                                 SKTexture(imageNamed: "PulseLevel2"),
                                 SKTexture(imageNamed: "ThuleLevel1"),
                                 SKTexture(imageNamed: "ThuleLevel2")]
        
        static let outOfPowerOverlay = SKTexture(imageNamed: "LowPwrOverlay")
    }
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
