//
//  PlayerButtonHandler.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 1/1/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerButtonHandler : NSObject {
    
    func buttonPressed(_ touchedNodes: [SKNode]) {
        for node in touchedNodes {
            //print(node.name)
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
