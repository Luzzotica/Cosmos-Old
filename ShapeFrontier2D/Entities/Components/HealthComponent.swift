//
//  HealthComponent.swift
//  DinoDefense
//
//  Created by Toby Stephens on 20/10/2015.
//  Copyright © 2015 razeware. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {

    let fullHealth: CGFloat
    var health: CGFloat
    let healthBarFullWidth: CGFloat
    let healthBar: SKShapeNode

    let soundAction = SKAction.playSoundFileNamed("smallHit.wav", waitForCompletion: false)

    init(parentNode: SKNode, barWidth: CGFloat,
           barOffset: CGFloat, health: CGFloat) {

        self.fullHealth = health
        self.health = health
        

        healthBarFullWidth = barWidth
        healthBar = SKShapeNode(rectOf:
          CGSize(width: healthBarFullWidth, height: 5), cornerRadius: 1)
        healthBar.fillColor = UIColor.green
        healthBar.strokeColor = UIColor.green
        healthBar.position = CGPoint(x: 0, y: barOffset)
        
        parentNode.addChild(healthBar)

        healthBar.isHidden = true
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult func takeDamage(_ damage: CGFloat) -> Bool {
        health = max(health - damage, 0)

        healthBar.isHidden = false
        let healthScale = health / fullHealth
        let scaleAction = SKAction.scaleX(to: healthScale, duration: 0.5)
        healthBar.run(SKAction.group([soundAction, scaleAction]))

        if health == 0 {
            if let entity = entity {
                EntityManager.shared.remove(entity)
            }
        }

        return health == 0
    }

}

