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
    
    func startConstructionMode(structure: Structure, location: CGPoint) {
        toBuild = structure
        
        toBuild!.isDisabled = true
        
        // Get the sprite components
        let spriteComponent = toBuild!.component(ofType: SpriteComponent.self)
        toBuildNode = spriteComponent!.node
        toBuildSprite = spriteComponent!.spriteNode
        
        // Update position
        toBuildNode!.position = location
        toBuildNode!.position.y += sceneHeight * 0.2 * PlayerHUD.shared.yScale
        
        // Update name and physics body
        toBuildNode!.name?.append("_underConstruction")
        
        toBuildNode!.physicsBody?.categoryBitMask = CollisionType.Construction
        toBuildNode!.physicsBody?.contactTestBitMask = CollisionType.Structure | CollisionType.PowerLine | CollisionType.Asteroid
        
        // Add connection range
        toBuildNode!.addChild(UIHandler.shared.createRangeIndicator(
            range: Structure.connection_length,
            color: .yellow))
        
        // Add to game scene
        addChild(toBuildNode!)
        
        // Make sure the scene knows we are currently building
        isBuilding = true
        
    }
    
    func updateConstruction(translation: CGPoint) {
        // Move the structure
        toBuildNode!.position += translation
        
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
            
            // Turn him to normal color
            let color = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.0)
            toBuildSprite!.run(color)
            
            // Made it, remove the name identifier
            for _ in 0...17 {
                toBuildNode!.name?.removeLast()
            }
            
            // Make him be a structure
            toBuildNode!.physicsBody?.categoryBitMask = CollisionType.Structure
            
            // Make him enabled
            toBuild?.isDisabled = false
            
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
            toBuildNode!.removeFromParent()
        }
        
        // Reset the building, connecting, and validity
        toBuild = nil
        toBuildNode = nil
        toBuildSprite = nil
        isValidSpot = false
        isBuilding = false
    }
    
    func searchStructuresInRange(isSupplier: Bool) -> [Structure] {
        var inRange : [Structure] = []
        var currentRange : CGFloat = sceneWidth
        
        for targetStructure in player_structures {
            // Get the target structure sprite
            let targetSpriteComponent = targetStructure.component(ofType: SpriteComponent.self)
            let targetSprite = targetSpriteComponent!.node
            
            // If he is a supplier, he can link to all people in range
            if isSupplier {
                if withinDistance(point1: targetSprite.position,
                                  point2: toBuildNode!.position,
                                  distance: Structure.connection_length).0 {
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
                                            point2: toBuildNode!.position,
                                            distance: Structure.connection_length)
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
