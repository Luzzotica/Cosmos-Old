//
//  HealthComponent.swift
//  Cosmos
//
//  Created by Sterling Long on 3/25/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {

    static var hideAction : SKAction!
    static var showAction : SKAction!
    
    var health_max: CGFloat
    var health_current: CGFloat
    let healthBarFullWidth: CGFloat
    let healthBar: SKShapeNode
    var healthBarShow: Bool
    
    var invulnerable = false

//    let soundAction = SKAction.playSoundFileNamed("smallHit.wav", waitForCompletion: false)

    init(parentNode: SKNode, barWidth: CGFloat,
         barOffset: CGFloat, health: CGFloat, showHealth: Bool = true) {

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
        healthBar.zPosition = Layer.InGameUI - parentNode.zPosition
        healthBarShow = showHealth
        
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
        health_current = max(min(health_max, health_current - damage), 0)

        updateHealthBar()

        // Kill him if he is dead
        if health_current == 0 {
            EntityManager.shared.remove(entity!)
        }

        // Return the current health of the target
        return health_current == 0
    }
    
    func heal(_ amount: CGFloat) {
        takeDamage(-amount)
    }
    
    func setHealth(_ amount: CGFloat) {
        // Clamp the health between 0 and max
        health_current = max(min(health_max, amount), 0)
        
        updateHealthBar()
        
        // Kill him if he is dead
        if health_current == 0 {
            EntityManager.shared.remove(entity!)
        }
    }
    
    func setMaxHealth(_ amount: CGFloat) {
        let amountChanged = amount - health_max
        
        health_max = amount
        health_current += amountChanged
        
        updateHealthBar()
    }
    
    func updateHealthBar() {
        // If the health bar can be shown, show it
        if healthBarShow {
            // Unhide the bar and create an action to scale it
            healthBar.isHidden = false
            let healthScale = health_current / health_max
            let scaleAction = SKAction.scaleX(to: healthScale, duration: 0.25)
            
            // remove all previous actions and run the new one
            healthBar.removeAllActions()
            healthBar.run(SKAction.group([scaleAction, HealthComponent.showAction, HealthComponent.hideAction]))
        }
    }
    
    func death() {
        // If we can get a root node
        if let root = healthBar.parent?.parent {
            // Get the death animation, and change it's size
            let deathAnim = SKEmitterNode(fileNamed: "StructureDeath")
            deathAnim?.particlePositionRange = CGVector(dx: healthBarFullWidth, dy: healthBarFullWidth)
            
            // Move it to where the structure is
            deathAnim?.position = healthBar.parent!.position
            deathAnim?.zPosition = Layer.DeathAnimation
            
            // Add the particle to the root
            root.addChild(deathAnim!)
            
            // Wait for a second, then remove it
            deathAnim?.run(SKAction.wait(forDuration: 1.0)) {
                deathAnim?.removeFromParent()
            }
        }
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


