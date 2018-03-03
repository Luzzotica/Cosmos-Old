//
//  PlayerButtonHandler.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 1/1/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit

extension PlayerHUD {
    
    func buttonPressedDown(_ touchedNodes: [SKNode], location: CGPoint) {
        for node in touchedNodes {
            //print(node.name)
            if node.name == nil {
                break
            }
            
            if (node.name?.contains("constructor"))! {
                constructionNode.startStructureCreation(name: node.name!, location: location)
                return
            }
        }
    }
    
    func buttonPressedUp(_ touchedNodes: [SKNode], location: CGPoint) {
        var functionToRun: (() -> Void)?
        var tappedEntity: Entity?
        
        for i in stride(from: touchedNodes.count - 1, through: 0, by: -1) {
            //print(touchedNodes[i].name)
            if touchedNodes[i].name == nil {
                continue
            }
            
            if touchedNodes[i].name == "button_pause" {
//                pauseGame()
                functionToRun = pauseGame
            }
            else if touchedNodes[i].name == "button_restart" {
//                restartGame()
                functionToRun = restartGame
            }
            else if touchedNodes[i].name == "button_upgrade" {
                
            }
            else if touchedNodes[i].name == "button_destroy" {
                functionToRun = PlayerHUD.shared.destroySelectedStructure
            }
            else if touchedNodes[i].name!.contains("entity") && !(touchedNodes[i].name!.contains("constructor")) {
                //print("touched a node! Function is: \(functionToRun)")
                // Check if we tapped on an entity
                print(touchedNodes[i].name!)
                tappedEntity = touchedNodes[i] as! Entity
            }
        }
        
        if functionToRun != nil {
            // If we tapped a button,
            functionToRun!()
        }
        else if tappedEntity != nil {
            // If we tapped an entity, display that entity in the info node
            displayInfo(entity: tappedEntity!)
        }
        else {
            // If we tapped on nothing, display the construction view on the bottom
            displayConstruction()
        }
    }
    
    func pauseGame() {
        
        if gameScene.pauseUnpause() {
            gameScene.addChild(UIHandler.shared.createPauseGameUI())
        }
        else {
            UIHandler.shared.destroyUI()
        }
    }
    
    func restartGame() {
        UIHandler.shared.destroyUI()
    }
    
}
