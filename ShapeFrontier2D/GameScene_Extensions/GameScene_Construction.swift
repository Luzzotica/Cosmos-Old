//
//  GameScene_Construction.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    // Mark: - Construction
    
    func startConstructionMode(structure: Structure) {
        toBuild = structure
        
        // Get the sprite components
        let spriteComponent = toBuild!.component(ofType: SpriteComponent.self)
        
        spriteComponent!.node.position.y += sceneHeight * 0.2 * PlayerHUD.shared.yScale
        
        // Add connection range
        spriteComponent!.spriteNode.addChild(UIHandler.shared.createRangeIndicator(
            range: connection_length,
            color: .yellow))
        
        // Add to game scene
        addChild(spriteComponent!.spriteNode)
        
        // Make sure the scene knows we are currently building
        isBuilding = true
        
    }
    
    func updateConstruction(translation: CGPoint) {
        let spriteComponent = toBuild!.component(ofType: SpriteComponent.self)
        
        // Move the structure
        spriteComponent!.node.position = spriteComponent!.node.position + translation
        
        // Get structures we can draw to
        let drawTo = searchStructuresInRange(isSupplier: toBuild!.isSupplier)
        
        if toBuild!.isSupplier {
            let toBuildSupplier = toBuild as! Supplier
            for structures in drawTo {
                toBuildSupplier.connection_addTo(structure: structures)
            }
            
            toBuildSupplier.connection_updateLines()
        }
        else {
            //print(drawTo)
            if drawTo.count > 0 {
                toBuild?.connection_addTo(structure: drawTo[0])
            }
            toBuild?.connection_updateLines()
        }
    }
    
    func endConstructionMode() {
        if isValidSpot {
            let spriteComponent = toBuild!.component(ofType: SpriteComponent.self)
            
            // Turn him to normal color
            let color = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.0)
            spriteComponent!.spriteNode.run(color)
            
            // Made it, remove the name identifier
            for _ in 0...17 {
                spriteComponent!.node.name?.removeLast()
            }
            
            // Make him be a structure
            spriteComponent!.node.physicsBody?.categoryBitMask = CollisionType.Structure
            
            // Make him enabled
            toBuild?.isDisabled = false
            
            // Remove his range indicator
            for i in stride(from: spriteComponent!.spriteNode.children.count - 1, through: 0, by: -1) {
                if spriteComponent!.spriteNode.children[i].name == "rangeIndicator" {
                    spriteComponent!.spriteNode.children[i].removeFromParent()
                }
            }
            
            // Mineral Cost
            minerals_current -= toBuild!.constructionCost
            PlayerHUD.shared.update_resources()
            
            // Finish Construction
            toBuild!.didFinishConstruction()
            
            // Add everything to structures
            player_structures.append(toBuild!)
            EntityManager.shared.add(toBuild!)
            
            // If this building was a reactor, add it to the players reactors
            // We will add batteries later...
            if toBuild! is Reactor {
                player_suppliers.append(toBuild as! Supplier)
            }
            // If it was a turret, add it to player's turrets
            if toBuild! is Turret {
                player_turrets.append(toBuild as! Turret)
            }
            // If it was a miner, add it to player's miners
            if toBuild! is Miner {
                player_miners.append(toBuild as! Miner)
            }
            
        }
        else {
            spriteComponent!.node.removeFromParent()
        }
        
        // Reset the building, connecting, and validity
        toBuild = nil
        isValidSpot = true
        isBuilding = false
    }
    
    func searchStructuresInRange(isSupplier: Bool) -> [Structure] {
        // Get the toBuild sprites
        let spriteComponent = toBuild!.component(ofType: SpriteComponent.self)
        
        var inRange : [Structure] = []
        var currentRange : CGFloat = sceneWidth
        
        for targetStructure in player_structures {
            // Get the target structure sprite
            let targetSpriteComponent = targetStructure.component(ofType: SpriteComponent.self)
            let targetSprite = targetSpriteComponent!.spriteNode
            
            // If he is a supplier, he can link to all people in range
            if isSupplier {
                if withinDistance(point1: targetSprite.position,
                                  point2: spriteComponent!.node.position,
                                  distance: connection_length).0 {
                    if !targetStructure.isSupplier && targetStructure.connection_powerLine == nil {
                        inRange.append(targetStructure)
                    }
                    else if targetStructure.isSupplier {
                        inRange.append(targetStructure)
                    }
                    
                }
            }
                // Otherwise, get the closest supplier
            else if targetStructure.isSupplier {
                let values = withinDistance(point1: targetSprite.position,
                                            point2: spriteComponent!.node.position,
                                            distance: connection_length)
                if values.0 {
                    if currentRange > values.1! {
                        currentRange = values.1!
                        inRange.removeAll()
                        inRange.append(targetStructure)
                    }
                }
            }
        }
        
        return inRange
    }
    
}
