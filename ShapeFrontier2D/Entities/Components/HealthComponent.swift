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

    static var hideAction : SKAction!
    static var showAction : SKAction!
    
    let health_max: CGFloat
    var health_current: CGFloat
    let healthBarFullWidth: CGFloat
    let healthBar: SKShapeNode
    
    var invulnerable = false

//    let soundAction = SKAction.playSoundFileNamed("smallHit.wav", waitForCompletion: false)

    init(parentNode: SKNode, barWidth: CGFloat,
           barOffset: CGFloat, health: CGFloat) {

        // Setup health variables
        self.health_max = health
        self.health_current = health
        
        // Setup the bar
        healthBarFullWidth = barWidth
        healthBar = SKShapeNode(rectOf:
          CGSize(width: healthBarFullWidth, height: 5), cornerRadius: 1)
        healthBar.fillColor = UIColor.green
        healthBar.strokeColor = UIColor.green
        healthBar.position = CGPoint(x: 0, y: barOffset)
        healthBar.zPosition = 2
        
        // Add him to the parent and hide him
        parentNode.addChild(healthBar)
        healthBar.alpha = 0.0
        
        // If our show and hide actions haven't been initialized, initalize them
        if HealthComponent.hideAction == nil && HealthComponent.showAction == nil {
            // Prepare the hide action for the health bar
            let hideTimer = SKAction.wait(forDuration: 4.0)
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            HealthComponent.hideAction = SKAction.sequence([hideTimer, fadeOut])
            
            // Prepare the show action for the health bar
            let fadeIn = SKAction.fadeIn(withDuration: 0.5)
            HealthComponent.showAction = SKAction.sequence([fadeIn])
        }
        
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult func takeDamage(_ damage: CGFloat) -> Bool {
        // If we are invulnerable, do nothing
        if invulnerable {
            return false
        }
        
        // Update current health
        health_current = max(health_current - damage, 0)

        // Unhide the bar and create an action to scale it
        healthBar.isHidden = false
        let healthScale = health_current / health_max
        let scaleAction = SKAction.scaleX(to: healthScale, duration: 0.25)
        
        // remove all previous actions and run the new one
        healthBar.removeAllActions()
        healthBar.run(SKAction.group([scaleAction, HealthComponent.showAction, HealthComponent.hideAction]))

        // Kill him if he is dead
        if health_current == 0 {
            if let entity = entity {
                EntityManager.shared.remove(entity)
            }
        }

        // Return the current health of the target
        return health_current == 0
    }
    
    func selected() {
        healthBar.removeAllActions()
        healthBar.run(HealthComponent.showAction)
    }
    
    func deselected() {
        healthBar.removeAllActions()
        healthBar.run(HealthComponent.hideAction)
    }

}


