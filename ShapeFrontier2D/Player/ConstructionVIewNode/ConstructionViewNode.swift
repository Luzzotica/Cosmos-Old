//
//  ConstructionHandler.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/5/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

struct StructureCost {
    static let Miner = 100
    static let Reactor = 300
    static let Node = 50
    static let PulseLaser = 250
    static let MissileTurret = 250
}

class ConstructionViewNode : SKNode {
    
    var constructionStructures : [ConstructionItem] = []
    
    init(bottomBar_height: CGFloat, bottomBar_buffer: CGFloat) {
        super.init()
        
        position.x = -sceneWidth * 0.5
        position.y = 0.0
        
        // Add all buildings you can make, in the order you want them
        constructionStructures.append(ConstructionItem(Reactor(texture: Structures.reactorLevel1,
                                                               teamID: "Construction")))
        constructionStructures.append(ConstructionItem(Miner(texture: Structures.miner,
                                                             teamID: "Construction")))
        constructionStructures.append(ConstructionItem(Node(texture: Structures.node,
                                                            teamID: "Construction")))
        constructionStructures.append(ConstructionItem(MissileCannon(texture: Structures.missileCannonLevel1,
                                                                     teamID: "Construction")))
        constructionStructures.append(ConstructionItem(PulseLaser(texture: Structures.pulseLaser,
                                                                  teamID: "Construction")))
        
        // Set the anchor point to the bottom left
        let anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let iconSize = CGSize(width: bottomBar_height, height: bottomBar_height)
        let xBuffer : CGFloat = bottomBar_buffer * 0.5
        let yBuffer : CGFloat = bottomBar_buffer * 0.5
        
        var point = CGPoint(x: xBuffer, y: yBuffer)
        
        for i in 0..<constructionStructures.count {
            constructionStructures[i].buildingSprite.size = iconSize
            constructionStructures[i].buildingSprite.position = point
            constructionStructures[i].buildingSprite.anchorPoint = anchorPoint
            
            point.x += iconSize.width + xBuffer
            
            addChild(constructionStructures[i].buildingSprite)
        }
    }
    
    func startStructureCreation(name: String, location: CGPoint) {
        var structure : Structure!
        
        if name.contains("constructor") {
            if name.contains("reactor") {
                let reactor = Reactor(texture: Structures.reactorLevel1)
                structure = reactor
                structure.constructionCost = StructureCost.Reactor
            }
            else if name.contains("miner") {
                let miner = Miner(texture: Structures.miner)
                miner.mySprite.addChild(UIHandler.shared.createRangeIndicator(range: miner.miningRange, color: .green))
                structure = miner
                structure.constructionCost = StructureCost.Miner
            }
            else if name.contains("node") {
                structure = Node(texture: Structures.node)
                structure.constructionCost = StructureCost.Node
            }
            else if name.contains("missileCannon") {
                let turret = MissileCannon(texture: Structures.missileCannonLevel1)
                turret.mySprite.addChild(UIHandler.shared.createRangeIndicator(range: turret.range, color: .red))
                structure = turret
                structure.constructionCost = StructureCost.MissileTurret
            }
            else if name.contains("pulseLaser") {
                let turret = PulseLaser(texture: Structures.pulseLaser)
                turret.mySprite.addChild(UIHandler.shared.createRangeIndicator(range: turret.range, color: .red))
                structure = turret
                structure.constructionCost = StructureCost.PulseLaser
            }
        }
        
        structure.isDisabled = true
        structure.mySprite.position = location
        structure.mySprite.name?.append("_underConstruction")
        
        structure.mySprite.physicsBody?.categoryBitMask = CollisionType.Construction
        structure.mySprite.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.PowerLine | CollisionType.Asteroid
        
        gameScene.startConstructionMode(structure: structure)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
