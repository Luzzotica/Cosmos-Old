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
    
    var structures : [BuildingItem] = []
    
    func setupConstructionView() {
        // Add all buildings you can make, in the order you want them
        structures.append(BuildingItem(Reactor()))
        structures.append(BuildingItem(Miner()))
        structures.append(BuildingItem(Node()))
        structures.append(BuildingItem(MissileCannon()))
        structures.append(BuildingItem(PulseLaser()))
        
        let anchorPoint = CGPoint(x: 0.0, y: 0.0)
        let iconSize = CGSize(width: sceneWidth * 0.08, height: sceneWidth * 0.08)
        let xBuffer : CGFloat = sceneWidth * 0.02
        let yBuffer : CGFloat = sceneHeight * 0.02
        
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
        case "ReactorConstructor": structure = Reactor()
        case "MinerConstructor": structure = Miner()
        case "NodeConstructor": structure = Node()
        case "MissileCannonConstructor": structure = MissileCannon()
        case "PulseLaserConstructor": structure = PulseLaser()
        default: structure = Structure()
        }
        
        structure.isDisabled = true
        structure.position = location
        
        gameScene.startConstructionMode(structure: structure)
    }
    
    func endStructureCreation() {
        gameScene.endConstructionMode()
    }
    
}
