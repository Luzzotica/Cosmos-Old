//
//  EntityManager.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

//
//  EntityManager.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    static let shared = EntityManager()
    
    var entities : Set<GKEntity> = Set()
    var entitiesForPlayer : [Int:Set<GKEntity>] = [:]
    var toRemove : Set<GKEntity> = Set()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        
        return [moveSystem]
    }()
    
    func add(_ entity: GKEntity) {
        // Add the entity to the global list
        entities.insert(entity)
        
        // Add all of their relevant components to the components systems so they will be updated
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        // If this was a sprite on the screen, add that sprite to the screen
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            if spriteNode.parent == nil {
                gameScene.addChild(spriteNode)
            }
        }
        
        // If they have a player component, add them to that specific playerEntity group
        if let playerComponent = entity.component(ofType: PlayerComponent.self) {
            // If this is the first time an entity has been added for this player
            // Create a new set for him
            if entitiesForPlayer[playerComponent.player] == nil {
                entitiesForPlayer[playerComponent.player] = Set<GKEntity>()
            }
            
            // Add the entity to the player's set
            entitiesForPlayer[playerComponent.player]?.insert(entity)
        }
    }
    
    func remove(_ entity: GKEntity) {
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    // This is going to get called a lot, we might want to save all of the agents for the players
    // It would make it a lot faster than looping through the components to find it on each entity...
    func agentComponentsForPlayer(_ player: Int) -> [MoveComponent] {
        
        // Get the entities tied to this player
        let entities = entitiesForPlayer[player]!
        
        // Get all of their move components, these are the agents that can be recognized by the AI
        var moveComponents : [MoveComponent] = []
        for entity in entities {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        
        // Return the agents of the player
        return moveComponents
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        // Loop through all of the systems and their components and update them all!
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        // Remove all the entities in the list to be removed
        for curRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: curRemove)
            }
        }
        
        // Clear out the list for the next iteration
        toRemove.removeAll()
    }
    
}

