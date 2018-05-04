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
    
    var players : Set<PlayerEntity> = Set()
    
    var entities : Set<GKEntity> = Set()
    var entitiesForPlayer : [Int:Set<GKEntity>] = [:]
    var toRemove : Set<GKEntity> = Set()
    
    // Obstacle graph
    var obstacles : [GKObstacle] = []
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        let contactSystem = GKComponentSystem(componentClass: ContactComponent.self)
        let rocketSystem_Linear = GKComponentSystem(componentClass: RocketLauncher_Linear.self)
        let rocketSystem_Tracer = GKComponentSystem(componentClass: RocketLauncher_Tracer.self)
        let traceSystem = GKComponentSystem(componentClass: TraceComponent.self)
        let pulseCannonSystem = GKComponentSystem(componentClass: LaserTurret.self)
        return [moveSystem, contactSystem, rocketSystem_Linear, rocketSystem_Tracer, traceSystem, pulseCannonSystem]
    }()
    
    func addPlayer(_ player: PlayerEntity) {
        players.insert(player)
    }
    
    func add(_ entity: GKEntity) {
        // Add the entity to the global list
        entities.insert(entity)
        
        // Add all of their relevant components to the components systems so they will be updated
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        // Get all of the necessary components from the entity
        let entityNode = entity.component(ofType: SpriteComponent.self)?.node
        let playerComponent = entity.component(ofType: PlayerComponent.self)
        let moveComponent = entity.component(ofType: MoveComponent.self)
        
        // Add the sprite node to our gamescene!
        if entityNode != nil && entityNode!.parent == nil {
            gameScene.addChild(entityNode!)
        }
        
        // Update the move component to match the position of the sprite
        if entityNode != nil && moveComponent != nil {
            moveComponent?.position = float2(entityNode!.position)
        }
        
        // If they have a player component, add them to that specific playerEntity group
        // This will handle asteroids as well, they are player 0, neutral
        if playerComponent != nil {
            // If this is the first time an entity has been added for this player
            // Create a new set for him
            if entitiesForPlayer[playerComponent!.player] == nil {
                entitiesForPlayer[playerComponent!.player] = Set<GKEntity>()
            }
            
            // Add the entity to the player's set
            entitiesForPlayer[playerComponent!.player]?.insert(entity)
            
            // Tell all the entities to update their pathing!
            for enemy in AllianceManager.shared.getPlayerEnemies(player: playerComponent!.player) {
                if entitiesForPlayer[enemy] == nil {
                    continue
                }
                for entity in entitiesForPlayer[enemy]! {
                    if let eMoveComponent = entity.component(ofType: MoveComponent.self) {
                        eMoveComponent.updatePathing()
                    }
                }
            }
        }
        
        // If the have an obstacle component, add it to our obstacles
        if let obstacleComp = entity.component(ofType: ObstacleComponent.self) {
            obstacles.append(obstacleComp.obstacle)
        }
        
    }
    
    func remove(_ entity: GKEntity) {
        
        if let node = entity.component(ofType: SpriteComponent.self)?.node {
            node.removeFromParent()
        }
        
        toRemove.insert(entity)
        entities.remove(entity)
        
        // Run the death action on the entity
        runDiedAction(entity)
        
        // If the entity was a player, remove him from the player set
        if let playerComponent = entity.component(ofType: PlayerComponent.self) {
            entitiesForPlayer[playerComponent.player]?.remove(entity)
            
            // loop through all of the player entities, update the HUD for each of them if this
            // person was their enemy
            for player in players {
//                print(playerComponent.player)
                if player.enemies.contains(playerComponent.player) {
                    player.enemyDied(entity)
                }
            }
            
            // Tell all the entities to update their pathing!
            for enemy in AllianceManager.shared.getPlayerEnemies(player: playerComponent.player) {
                if entitiesForPlayer[enemy] == nil {
                    continue
                }
                for entity in entitiesForPlayer[enemy]! {
                    if let moveComponent = entity.component(ofType: MoveComponent.self) {
                        moveComponent.updatePathing()
                    }
                }
            }
        }
    }
    
    func runDiedAction(_ entity: GKEntity) {
        if entity is Structure {
            (entity as! Structure).didDied()
            gameScene.structureDied(structure: (entity as! Structure))
        }
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

