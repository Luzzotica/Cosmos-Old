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
    
    // Bottom bar!
    let bottomBarNode = SKNode()
    let bottomBar_height = sceneHeight * 0.18
    let bottomBar_buffer = sceneHeight * 0.07
    
    // Construction Node!
    var constructionNode : ConstructionViewNode!
    
    // Info Node!
    var infoNode : InfoViewNode!
    
    // Resource Node!
    var resourceNode : ResourceViewNode!
    
    override init() {
        super.init()
        
        // Set his position to the center of the map
        position.x = sceneWidth * 0.5
        position.y = sceneHeight * 0.5
        zPosition = Layer.UI
        name = "mainCamera"
        
        // Move the bottom bar down, and add the bottom bar to the camera
        bottomBarNode.position.y = -sceneHeight * 0.5
        addChild(bottomBarNode)
        
        // initialize resourceNode, infoNode, and constructionNode
        constructionNode = ConstructionViewNode(bottomBar_height: bottomBar_height, bottomBar_buffer: bottomBar_buffer)
        infoNode = InfoViewNode(bottomBar_height: bottomBar_height, bottomBar_buffer: bottomBar_buffer)
        resourceNode = ResourceViewNode(bottomBar_height: bottomBar_height, bottomBar_buffer: bottomBar_buffer)
        
        displayConstruction()
        
        // Add the resource node to the bottom bar
        bottomBarNode.addChild(constructionNode)
        bottomBarNode.addChild(infoNode)
        bottomBarNode.addChild(resourceNode)
        
        
        // COOL UI STUFF
        // Add background UI for the bottom area
        bottomBarNode.addChild(createConstructionViewBackground())
    }
    
    func resetHUD() {
        displayConstruction()
    }
    
    // Info Node
    func displayInfo(entity: Entity) {
        infoNode.displayInfo(entity: entity)
        
        constructionNode.isHidden = true
        infoNode.isHidden = false
    }
    
    func displayConstruction() {
        constructionNode.isHidden = false
        infoNode.isHidden = true
    }
    
    func destroySelectedStructure() {
        displayConstruction()
        infoNode.destroySelectedStructure()
    }
    
    func updateHUD() {
        if !infoNode.isHidden {
            infoNode.updateInfo()
        }
    }
    
    // Resources
    func update_resources() {
        resourceNode.update_resources()
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
