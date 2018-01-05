//
//  File.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 12/29/17.
//  Copyright © 2017 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerHUDHandler : NSObject {
    static let shared = PlayerHUDHandler()
    
    let playerButtonHandler = PlayerButtonHandler()
    
    var playerCamera : SKCameraNode!
    
    func setupHUD() -> SKCameraNode {
        // Create a camera node and shift it to center the scene
        // All UI will be attached to it
        playerCamera = SKCameraNode()
        playerCamera.position.x = sceneWidth * 0.5
        playerCamera.position.y = sceneHeight * 0.5
        playerCamera.zPosition = Layer.UI
        playerCamera.name = "mainCamera"
        
        // setup other game handlers and all their glorious things, add them to the camera
        
        return playerCamera
    }
    
    func resetHUD() {
        
    }
    
    //
    
    func buttonPressed(touchedNodes: [SKNode]) {
        playerButtonHandler.buttonPressed(touchedNodes)
    }
    
    // Score handler stuff
//    func handleScore(name: String) {
//        playerLeftHUD.handleScore(name: name)
//    }
    
}
