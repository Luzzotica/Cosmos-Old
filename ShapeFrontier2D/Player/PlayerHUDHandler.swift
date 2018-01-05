//
//  File.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 12/29/17.
//  Copyright © 2017 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

import CollectionNode


class PlayerHUDHandler : NSObject {
    static let shared = PlayerHUDHandler()
    private override init() {}
    
    let playerButtonHandler = PlayerButtonHandler()
    let constructionManager = ConstructionManager()
	let playerResourceHUD = PlayerResourcesHUD()
    
    var playerCamera : SKCameraNode!
    
    
    func setupHUD() -> SKCameraNode {
        // Create a camera node and shift it to center the scene
        // All UI will be attached to it
        playerCamera = SKCameraNode()
        playerCamera.position.x = sceneWidth * 0.5
        playerCamera.position.y = sceneHeight * 0.5
        playerCamera.zPosition = Layer.UI
        playerCamera.name = "mainCamera"
        
        playerResourceHUD.setup()
        playerCamera.addChild(playerResourceHUD)
        
        // Setup Building Constructor
        playerCamera.addChild(constructionManager)
        
        return playerCamera
    }
    
    func resetHUD() {
        
    }
    
    // Move the camera function
    func cameraMoved(dPoint: CGPoint) {
        playerCamera.position = playerCamera.position - dPoint
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
    
    // Button Handler stuff
    
    func buttonPressedDown(touchedNodes: [SKNode], touchedLocation: CGPoint) {
        playerButtonHandler.buttonPressedDown(touchedNodes, location: touchedLocation)
    }
    
    func buttonPressedUp(touchedNodes: [SKNode], touchedLocation: CGPoint) {
        playerButtonHandler.buttonPressedUp(touchedNodes, location: touchedLocation)
    }
    
    // Score handler stuff
//    func handleScore(name: String) {
//        playerLeftHUD.handleScore(name: name)
//    }
    
}
