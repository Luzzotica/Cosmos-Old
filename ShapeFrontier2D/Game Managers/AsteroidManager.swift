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
        
        let clusterRadius = Int(arc4random_uniform(UInt32(sceneWidth * 0.6))) + Int(sceneWidth * 0.4)
        
        var currentMinerals = mineralCap
        
        while currentMinerals > 100 {
            // Randomize radius, and, and minerals to give
            let radius = Int(arc4random_uniform(UInt32(clusterRadius)))
            let angle = Double(arc4random_uniform(361))
            let minerals = Int(arc4random_uniform(501))
            
            // Get the point based on radius and angle
            let x = atPoint.x + CGFloat((cos(angle) * Double(radius)))
            let y = atPoint.y + CGFloat((sin(angle) * Double(radius)))
            
            // Create the asteroid at the point, add it to the cluster
            let asteroid = createAsteroid(minerals: minerals, atPoint: CGPoint(x: x, y: y))
            asteroid.zRotation = CGFloat(angle)
            clusterNode.addChild(asteroid)
            
            // Subtract from mineralcap
            currentMinerals -= minerals
        }
        
        return clusterNode
    }
    
    func createAsteroid(minerals: Int, atPoint: CGPoint) -> Asteroid {
        
        let mineralThreshold = 250
        
        if minerals < mineralThreshold {
            let asteroid = AsteroidSmall(minerals: minerals)
            asteroid.position = atPoint
            return asteroid
        }
        else {
            let asteroid = AsteroidBig(minerals: minerals)
            asteroid.position = atPoint
            return asteroid
        }
        
    }
    
}
