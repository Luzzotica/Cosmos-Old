//
//  File.swift
//  DOTKey Resistance
//
//  Created by Sterling Long on 12/29/17.
//  Copyright © 2017 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerHUD : SKCameraNode {
    
    static let shared = PlayerHUD()
    
    let bottomBarNode = SKNode()
    
    let constructionNode = SKNode()
    let resourceNode = SKNode()
    let powerNode = SKNode()
    let mineralNode = SKNode()
    
    // Construction Node Variables
    var structures : [ConstructionItem] = []
    
    // Resource Node Variables
    var resourceHUDWidth: CGFloat = sceneWidth * 0.25
    
    // Power variables
    var powerLevelNode: SKSpriteNode!
    var powerLevelLabel: SKLabelNode!
    let powerLevelBarHeight : CGFloat = sceneHeight * 0.04
    
    // Mineral variables
    var mineralsLevelLabel: SKLabelNode!
    var mininigRateLabel: SKLabelNode!
    
    override init() {
        super.init()
        
        // Set hit position to the center of the map
        position.x = sceneWidth * 0.5
        position.y = sceneHeight * 0.5
        zPosition = Layer.UI
        name = "mainCamera"
        
        // Add the bottom bar to the camera
        addChild(bottomBarNode)
        
        // setup and add the resource node to the bottom bar
        setupResourceView()
        bottomBarNode.addChild(resourceNode)
        
        // Setup Building Constructor and add him to the bottom bar
        setupConstructionView()
        addChild(constructionNode)
        
        // Add background UI for the bottom area
        addChild(createConstructionViewBackground())
    }
    
    func resetHUD() {
        
    }
    
    // Move the camera function
    func cameraMoved(dPoint: CGPoint) {
        position = position - dPoint
    }
    
    func zoom(scale: CGFloat) {
        
        // If the scale of the camera is already <= the threshold, abort pinch
        if (scale > 1) {
            if (xScale <= 0.1) {
                return
            }
        }
        
        // If the scale of the camera is already >= the threshold, abort zoom
        if (scale < 1) {
            if (xScale >= 10.0) {
                return;
            }
        }
        
        run(SKAction.scale(by: 1.0 / scale, duration: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Score handler stuff
//    func handleScore(name: String) {
//        playerLeftHUD.handleScore(name: name)
//    }
    
}
