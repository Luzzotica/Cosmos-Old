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
        structures.append(ConstructionItem(Reactor()))
        structures.append(ConstructionItem(Miner()))
        structures.append(ConstructionItem(Node()))
        structures.append(ConstructionItem(MissileCannon()))
        structures.append(ConstructionItem(PulseLaser()))
        
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
        case "ReactorConstructor": structure = Reactor()
        case "MinerConstructor":
            let miner = Miner()
            miner.addChild(UIHandler.shared.createRangeIndicator(range: miner.miningRange, color: .green))
            structure = miner
        case "NodeConstructor": structure = Node()
        case "MissileCannonConstructor":
            let turret = MissileCannon()
            turret.addChild(UIHandler.shared.createRangeIndicator(range: turret.range, color: .red))
            structure = turret
        case "PulseLaserConstructor":
            let turret = PulseLaser()
            turret.addChild(UIHandler.shared.createRangeIndicator(range: turret.range, color: .red))
            structure = turret
        default: structure = Structure()
        }
        
        structure.isDisabled = true
        structure.position = location
        structure.name?.append("UnderConstruction")
        
        gameScene.startConstructionMode(structure: structure)
    }
    
}
