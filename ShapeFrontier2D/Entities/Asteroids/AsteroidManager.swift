//
//  AsteroidManager.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class AsteroidManager : NSObject {
    
    static let shared = AsteroidManager()
    
    func createAsteroidCluster(atPoint: CGPoint, mineralCap: Int) -> [Asteroid] {
        var cluster : [Asteroid] = []
        
        let clusterRadius = Int(sceneWidth * 2.0)
        
        var currentMinerals = mineralCap
        
        while currentMinerals > 100 {
            // Randomize radius, and, and minerals to give
            let radius = Int(arc4random_uniform(UInt32(clusterRadius))) + Int(sceneWidth * 0.2)
            let angle = Double(arc4random_uniform(361))
            let minerals = Int(arc4random_uniform(6000))
            
            // Get the point based on radius and angle
            let x = atPoint.x + CGFloat((cos(angle) * Double(radius)))
            let y = atPoint.y + CGFloat((sin(angle) * Double(radius)))
            
            // Create the asteroid at the point, add it to the cluster
            let asteroid = createAsteroid(minerals: minerals, atPoint: CGPoint(x: x, y: y), withAngle: CGFloat(angle))
            
            // Add it to the clusternode
            cluster.append(asteroid)
            
            // Subtract from mineralcap
            currentMinerals -= minerals
        }
        
        return cluster
    }
    
    func createAsteroid(minerals: Int, atPoint: CGPoint, withAngle: CGFloat) -> Asteroid {
        
        let smallThreshold = 2000
        let mediumThreshold = 4000
        
        let textures = getRandomAsteroid()
        if minerals < smallThreshold {
            let asteroid = AsteroidSmall(texture: textures.asteroidTexture, gasTexture: textures.gasTexture, minerals: minerals)
            
            let spriteComponent = asteroid.component(ofType: SpriteComponent.self)
            spriteComponent!.node.position = atPoint
            spriteComponent!.spriteNode.zRotation = withAngle
            if let obstacleComponent = asteroid.component(ofType: ObstacleComponent.self) {
                obstacleComponent.obstacle.position = float2(spriteComponent!.node.position)
            }
            return asteroid
        }
        else if minerals < mediumThreshold {
            let asteroid = AsteroidMedium(texture: textures.asteroidTexture, gasTexture: textures.gasTexture, minerals: minerals)
            
            let spriteComponent = asteroid.component(ofType: SpriteComponent.self)
            spriteComponent!.node.position = atPoint
            spriteComponent!.spriteNode.zRotation = withAngle
            if let obstacleComponent = asteroid.component(ofType: ObstacleComponent.self) {
                obstacleComponent.obstacle.position = float2(spriteComponent!.node.position)
            }
            return asteroid
        }
        else {
            let asteroid = AsteroidBig(texture: textures.asteroidTexture, gasTexture: textures.gasTexture, minerals: minerals)
            
            let spriteComponent = asteroid.component(ofType: SpriteComponent.self)
            spriteComponent!.node.position = atPoint
            spriteComponent!.spriteNode.zRotation = withAngle
            if let obstacleComponent = asteroid.component(ofType: ObstacleComponent.self) {
                obstacleComponent.obstacle.position = float2(spriteComponent!.node.position)
            }
            return asteroid
        }
        
    }
    
    func getRandomAsteroid() -> (asteroidTexture: SKTexture, gasTexture: SKTexture){
        let randomA = Int(arc4random_uniform(UInt32(4)))
        let randomG = Int(arc4random_uniform(UInt32(4)))
        
        return (Asteroids.asteroids[randomA], Asteroids.asteroidGas[randomG])
    }
    
}
