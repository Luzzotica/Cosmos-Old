//
//  Structure.swift
//  Cosmos
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Structure : GKEntity {
    
    var playerID : Int
    
    var level : Int = 0
    
    // Construction variables
    var constructionCost = 0
    
    var isSupplier: Bool {
        return let _ = self.component(ofType: PowerStorageComponent)
    }
    
    var power_lowOverlay : SKSpriteNode!
    
    var isDisabled = false
    var isBuilt = true
    
    func select() {
        // Create the range indicator
        
    }
    
    func deselect() {
        // Deselect our structure
        let spriteComponent = component(ofType: SpriteComponent.self)
        spriteComponent!.deselect()
    }
    
    func didDied() {
        //Remove self from global structures list and individual type list
        connection_powerLine?.destroySelf()
    }
    
    func upgrade_start() {
        
    }
    
    func upgrade_finish() {
        upgrade_setLevel(level: self.level + 1)
    }
    
    func upgrade_setLevel(level: Int) {
        
    }
    
    func upgrade_isMaxLevel() -> Bool {
        return false
    }
    
    // MARK: - Construction
    
    func didFinishPlacement() {
        print("Got build component")
        
        connection_findMasters()
        connection_powerLine?.constructPowerLine()
        
        power_handleOverlay()
        
        // Update the positioning of the move component, and GKGraphNode
        if let moveComponent = component(ofType: MoveComponent.self),
            let spriteComponent = component(ofType: SpriteComponent.self) {
            moveComponent.position = float2(spriteComponent.node.position)
        }
        
        // Deselect our man
        deselect()
    }
    
    func didFinishConstruction() {
        
    }
    
    init(texture: SKTexture, size: CGSize, playerID: Int) {
        self.playerID = playerID
        print(playerID)
        
        super.init()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
