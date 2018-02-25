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
        for i in stride(from: touchedNodes.count - 1, through: 0, by: -1) {
            print(touchedNodes[i].name)
            if touchedNodes[i].name == nil {
                continue
            }
            
            if touchedNodes[i].name == "button_pause" {
                pauseGame(touchedNodes[i])
                return
            }
            else if touchedNodes[i].name == "button_restart" {
                restartGame()
                return
            }
            else if touchedNodes[i].name == "button_upgrade" {
                
                return
            }
            else if touchedNodes[i].name == "button_destroy" {
                PlayerHUD.shared.destroySelectedStructure()
                return
            }
            else if touchedNodes[i].name!.contains("entity") && !(touchedNodes[i].name!.contains("constructor")) {
                print(touchedNodes[i].name!)
                PlayerHUD.shared.displayInfo(entity: touchedNodes[i] as! Entity)
                return
            }
        }
        
        PlayerHUD.shared.displayConstruction()
    }
    
    func pauseGame(_ node: SKNode) {
        
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
