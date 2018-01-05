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
    
    func cameraMoved(dx: CGFloat, dy: CGFloat) {
        playerCamera.position.x -= dx
        playerCamera.position.y -= dy
    }
    
    func zoom(scale: CGFloat) {
        
        
        // If the scale of the camera is already <= the threshold, abort pinch
        if (scale > 1) {
            if (playerCamera.xScale <= 0.1) {
                return
            }
        }
        
        // If the scale of the camera is already >= the threshold, abort zoom
        if (scale < 1) {
            if (playerCamera.xScale >= 10.0) {
                return;
            }
        }
        
        
        playerCamera.run(SKAction.scale(by: 1.0 / scale, duration: 0))
        
        print(playerCamera.xScale)
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
