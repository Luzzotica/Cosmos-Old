//
//  PlayerButtonHandler.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 1/1/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

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
        if touchedNodes.count == 0 {
            print("Got here? Not really possible...")
            return
        }
        
        var functionToRun: (() -> Void)?
        var tappedEntity: GKEntity?
        
        for i in stride(from: 0, to: touchedNodes.count, by: 1) {
            if touchedNodes[i].name == nil {
                continue
            }
//            print(touchedNodes[i].name)
            
            if touchedNodes[i].name!.contains("power_line") {
                break
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
                functionToRun = destroySelectedStructure
            }
            else if touchedNodes[i].name == "button_new_wave" {
                functionToRun = spawnWave
            }
            else if touchedNodes[i].name!.contains("entity") && !(touchedNodes[i].name!.contains("constructor")) {
                //print("touched a node! Function is: \(functionToRun)")
                // Check if we tapped on an entity
//                print(touchedNodes[i].name!)
                tappedEntity = touchedNodes[i].entity
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
    
    func spawnWave() {
        gameScene.spawnWave()
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
