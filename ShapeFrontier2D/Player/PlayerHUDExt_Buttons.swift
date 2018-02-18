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
            
            if (node.name?.contains("Constructor"))! {
                startStructureCreation(name: node.name!, location: location)
                return
            }
        }
    }
    
    func buttonPressedUp(_ touchedNodes: [SKNode], location: CGPoint) {
        for node in touchedNodes {
            //print(node.name)
            if node.name == nil {
                break
            }
            
            if node.name == "button_pause" {
                pauseGame(node)
                return
            }
            else if node.name == "button_restart" {
                restartGame()
                return
            }
        }
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
