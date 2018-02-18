//
//  ConstructionHandler.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class ConstructionManager : SKNode {
    
    var structures : [ConstructionItem] = []
    
    func setupConstructionView() {
        // Add all buildings you can make, in the order you want them
        structures.append(ConstructionItem(Reactor(texture: Structures.reactorLevel1)))
        structures.append(ConstructionItem(Miner(texture: Structures.miner)))
        structures.append(ConstructionItem(Node(texture: Structures.node)))
        structures.append(ConstructionItem(MissileCannon(texture: Structures.missileCannonLevel1)))
        structures.append(ConstructionItem(PulseLaser(texture: Structures.pulseLaser)))
        
        let anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let iconSize = CGSize(width: sceneWidth * 0.1, height: sceneWidth * 0.1)
        let xBuffer : CGFloat = sceneWidth * 0.04
        let yBuffer : CGFloat = sceneHeight * 0.04
        
        var point = CGPoint(x: xBuffer, y: yBuffer)
        
        for i in 0..<structures.count {
            structures[i].building.size = iconSize
            structures[i].building.position = point
            structures[i].building.anchorPoint = anchorPoint
            
            point.x += iconSize.width + xBuffer
            
            addChild(structures[i].building)
        }
    }
    
    override init() {
        super.init()
        
        position.x = -sceneWidth * 0.5
        position.y = -sceneHeight * 0.5
        
        setupConstructionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlayerButtonHandler {
    
    func startStructureCreation(name: String, location: CGPoint) {
        var structure : Structure!
        
        switch name {
        case "ReactorConstructor":
            let reactor = Reactor(texture: Structures.reactorLevel1)
            structure = reactor
            structure.constructionCost = StructureCost.Reactor
        case "MinerConstructor":
            let miner = Miner(texture: Structures.miner)
            miner.addChild(UIHandler.shared.createRangeIndicator(range: miner.miningRange, color: .green))
            structure = miner
            structure.constructionCost = StructureCost.Miner
        case "NodeConstructor":
            structure = Node(texture: Structures.node)
            structure.constructionCost = StructureCost.Node
        case "MissileCannonConstructor":
            let turret = MissileCannon(texture: Structures.missileCannonLevel1)
            turret.addChild(UIHandler.shared.createRangeIndicator(range: turret.range, color: .red))
            structure = turret
            structure.constructionCost = StructureCost.MissileTurret
        case "PulseLaserConstructor":
            let turret = PulseLaser(texture: Structures.pulseLaser)
            turret.addChild(UIHandler.shared.createRangeIndicator(range: turret.range, color: .red))
            structure = turret
            structure.constructionCost = StructureCost.PulseLaser
        default: structure = Structure(texture: Structures.reactorLevel1)
        }
        
        structure.isDisabled = true
        structure.position = location
        structure.name?.append("UnderConstruction")
        
        structure.physicsBody?.categoryBitMask = CollisionType.Construction
        structure.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.PowerLine | CollisionType.Asteroid
        
        gameScene.startConstructionMode(structure: structure)
    }
    
}

struct StructureCost {
    static let Miner = 100
    static let Reactor = 300
    static let Node = 50
    static let PulseLaser = 250
    static let MissileTurret = 250
    
}
