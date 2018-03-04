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
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        
        return [moveSystem]
    }()
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            if spriteNode.parent == nil {
                gameScene.addChild(spriteNode)
            }
        }
        
    }
    
    func remove(_ entity: GKEntity) {
        
        if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        toRemove.insert(entity)
        entities.remove(entity)
    }
    
    func entitiesOnTeam(_ team: Team) -> [GKEntity] {
        
        return entities.flatMap { entity in
            if let teamComponent = entity.component(ofType: TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
        
    }
    
    func moveComponentsOnTeam(_ team: Team) -> [MoveComponent] {
        let entities = entitiesOnTeam(team)
        var moveComponents = [MoveComponent]()
        for entity in entities {
            if let moveComponent = entity.component(ofType: MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
        }
        return moveComponents
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for curRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: curRemove)
            }
        }
        toRemove.removeAll()
    }
    
}

