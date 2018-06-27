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
        constructionStructures.append(ConstructionItem(Reactor(playerID: GameConfiguration.Player.neutral)))
        constructionStructures.append(ConstructionItem(Miner(playerID: GameConfiguration.Player.neutral)))
        constructionStructures.append(ConstructionItem(Node(playerID: GameConfiguration.Player.neutral)))
        constructionStructures.append(ConstructionItem(MissileCannon(playerID: GameConfiguration.Player.neutral)))
        constructionStructures.append(ConstructionItem(PulseCannon(playerID: GameConfiguration.Player.neutral)))
        
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
        
        // Get the player from the HUD
        guard let player = PlayerHUD.shared.playerEntity else { return }
        
        print("TEST")
        
//        print(name)
        if name.contains("constructor") {
            if name.contains("reactor") {
                let reactor = Reactor(playerID: player.playerID)
                structure = reactor
                structure.constructionCost = StructureCost.Reactor
            }
            else if name.contains("miner") {
                let miner = Miner(playerID: player.playerID)
                miner.select()
                structure = miner
                structure.constructionCost = StructureCost.Miner
            }
            else if name.contains("node") {
                structure = Node(playerID: player.playerID)
                structure.constructionCost = StructureCost.Node
            }
            else if name.contains("missileCannon") {
                let turret = MissileCannon(playerID: player.playerID)
                turret.select()
                structure = turret
                structure.constructionCost = StructureCost.MissileTurret
            }
            else if name.contains("pulseLaser") {
                let turret = PulseCannon(playerID: player.playerID)
                turret.select()
                structure = turret
                structure.constructionCost = StructureCost.PulseLaser
            }
        }
        
        gameScene.startConstructionMode(structure: structure, location: location)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
