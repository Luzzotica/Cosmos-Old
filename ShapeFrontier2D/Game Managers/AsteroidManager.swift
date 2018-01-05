//
//  AsteroidManager.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class AsteroidManager : NSObject {
    
    
    
    func createAsteroidCluster(atPoint: CGPoint, mineralCap: Int) -> SKNode {
        let clusterNode = SKNode()
        
        let clusterRadius = Int(arc4random_uniform(UInt32(sceneWidth * 0.6))) + Int(sceneWidth * 0.2)
        
        var currentMinerals = mineralCap
        
        //let asteroidTexture = SKTexture(image: #imageLiteral(resourceName: "Asteroid1"))
        //let asteroidTexture = SKTexture(imageNamed: "Asteroid1")
        
        while currentMinerals > 100 {
            // Randomize radius, and, and minerals to give
            let radius = Int(arc4random_uniform(UInt32(clusterRadius))) + Int(sceneWidth * 0.2)
            let angle = Double(arc4random_uniform(361))
            let minerals = Int(arc4random_uniform(801))
            
            // Get the point based on radius and angle
            let x = atPoint.x + CGFloat((cos(angle) * Double(radius)))
            let y = atPoint.y + CGFloat((sin(angle) * Double(radius)))
            
            // Create the asteroid at the point, add it to the cluster
//            let asteroid = createAsteroid(minerals: minerals, atPoint: CGPoint(x: x, y: y))
            let asteroid = PulseLaser(texture: Structures.pulseLaserLevel1)
            asteroid.position = CGPoint(x: x, y: y)
            asteroid.zRotation = CGFloat(angle)
            
            //asteroid.texture = asteroidTexture
            
            clusterNode.addChild(asteroid)
            
            // Subtract from mineralcap
            currentMinerals -= minerals
        }
        
        return clusterNode
    }
    
    func createAsteroid(minerals: Int, atPoint: CGPoint) -> Asteroid {
        
        let smallThreshold = 250
        let mediumThreshold = 600
        
        if minerals < smallThreshold {
            let asteroid = AsteroidSmall(texture: Asteroids.asteroid1, minerals: minerals)
            asteroid.position = atPoint
            return asteroid
        }
        else if minerals < mediumThreshold {
            let asteroid = AsteroidMedium(texture: Asteroids.asteroid1, minerals: minerals)
            asteroid.position = atPoint
            return asteroid
        }
        else {
            let asteroid = AsteroidBig(texture: Asteroids.asteroid1, minerals: minerals)
            asteroid.position = atPoint
            return asteroid
        }
        
    }
    
}
