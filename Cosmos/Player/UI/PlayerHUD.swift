//
//  PlayerHUD.swift
//  Cosmos
//
//  Created by Sterling Long on 12/29/17.
//  Copyright © 2017 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerHUD : SKCameraNode {
    // MARK: - Properties
    
    static let shared = PlayerHUD()
    weak var playerEntity : PlayerEntity! {
        didSet {
            print("playerEntity set")
        }
    }
    
    // Max camera range
    let cameraRange = sceneWidth * 5.0
    
    // Bottom bar!
    let bottomBarNode = SKNode()
    let bottomBar_height = sceneHeight * 0.13
    let bottomBar_buffer = sceneHeight * 0.03
    
    // Construction Node!
    var constructionNode : ConstructionViewNode!
    
    // Info Node!
    var infoNode : InfoViewNode!
    
    // Resource Node!
    var resourceNode : ResourceViewNode!
    
    // Enemy Indicator Node!
    var enemyIndicatorManager : EnemyIndicatorManager!
    
    // Background Node
    let backgroundNode = SKNode()
    var backgroundOne = SKNode()
    var backgroundTwo = SKNode()
    
    // MARK: - Initializers
    
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
        
        // Setup button listeners
        infoNode.destroyButton.setListener(function: destroySelectedStructure)
        infoNode.upgradeButton.setListener(function: upgradeSelectedStructure)
        
        // Add the resource node to the bottom bar
        bottomBarNode.addChild(constructionNode)
        bottomBarNode.addChild(infoNode)
        bottomBarNode.addChild(resourceNode)
        
        // COOL UI STUFF
        // Add background UI for the bottom area
        bottomBarNode.addChild(createConstructionViewBackground())
        
        // Add the background!
        createBackground()
        
        // Add the enemy indicator manager
        enemyIndicatorManager = EnemyIndicatorManager()
        addChild(enemyIndicatorManager)
        
        // Add a new wave button
        let newWaveSize = CGSize(width: sceneWidth * 0.17, height: sceneHeight * 0.1)
        let newWave = UI_Button(size: newWaveSize, text: "New Wave", name: "new_wave", anchor: CGPoint(x: 1.0, y: 1.0))
        newWave.position = CGPoint(x: sceneWidth * 0.5, y: sceneHeight * 0.5)
        newWave.setListener(function: spawnWave)
        
        addChild(newWave)
    }
    
    func resetHUD() {
        displayConstruction()
    }
    
    // MARK: - Info Node
    
    func displayInfo(entity: GKEntity) {
        infoNode.displayInfo(entity: entity)
        
        constructionNode.isHidden = true
        infoNode.isHidden = false
    }
    
    func displayConstruction() {
        constructionNode.isHidden = false
        infoNode.isHidden = true
        
        // Deselect the entity
        infoNode.deselectEntity()
    }
    
    func destroySelectedStructure() {
        displayConstruction()
        infoNode.destroySelectedStructure()
    }
    
    func upgradeSelectedStructure() {
        infoNode.upgradeSelectedStructure()
    }
    
    func updateHUD() {
        if !infoNode.isHidden {
            infoNode.updateInfo()
        }
        
        if playerEntity != nil {
            enemyIndicatorManager.update(player: playerEntity)
        }
    }
    
    func enemyDied(_ enemy: GKEntity) {
        enemyIndicatorManager.removeEnemy(enemy)
    }
    
    // Resources
    func update_resources() {
        resourceNode.update_resources()
    }
    
    // MARK: - Camera Actions
    
    func cameraMoved(dPoint: CGPoint) {
        
        // Check if we are out of bounds
        var transPoint = dPoint
        if abs(position.x - transPoint.x) > cameraRange {
            transPoint.x = 0
        }
        
        if abs(position.y - transPoint.y) > cameraRange {
            transPoint.y = 0
        }
        
        // Move the camera
        position = position - transPoint
        
        // Parallax the background
        var backgroundPoint = (backgroundOne.position + transPoint * 0.05)
        backgroundOne.position = backgroundPoint
        backgroundPoint *= 1.3
        backgroundTwo.position = backgroundPoint
    }
    
    func zoom(scale: CGFloat) {
        
        // If the scale of the camera is already <= the threshold, abort pinch
        if (scale > 1) {
            if (xScale <= 1.0) {
                return
            }
        }
        
        // If the scale of the camera is already >= the threshold, abort zoom
        if (scale < 1) {
            if (xScale >= 10.0) {
                return
            }
        }
        
        //
        var backgroundScale = 1.0 - scale
        backgroundScale *= 0.9
        backgroundScale += 1
//        print(scale)
        let scaleAction = SKAction.scale(by: 1.0 / scale, duration: 0)
        run(scaleAction)
        backgroundNode.run(SKAction.scale(by: 1.0 / backgroundScale, duration: 0))
    }
    
    // MARK: - Background Creation
    
    func createBackground() {
        
        let backgroundTexture1 = SKTexture(imageNamed: "StarsOnlyUpper")
        let backgroundTexture2 = SKTexture(imageNamed: "StarsOnlyLower")
        
        // Add in the stars, make them cover a massive area!
        let backgroundSize = CGSize(width: sceneWidth, height: sceneWidth)
        
        let gridCount = 15
        for i in 0...gridCount {
            for j in 0...gridCount {
                // Get a grid position, slightly overlapping
                let position = CGPoint(x: backgroundSize.width * 0.9 * CGFloat(i), y: backgroundSize.height * 0.9 * CGFloat(j))
                
                let scale = CGFloat(pow(-1.0, Double(i + j)))
                
                var background = SKSpriteNode(texture: backgroundTexture1)
                background.size = backgroundSize
                background.position = position
                background.zPosition = Layer.Background3 - self.zPosition
                
                background.xScale = scale
                backgroundOne.addChild(background)
                
                background = SKSpriteNode(texture: backgroundTexture2)
                background.size = backgroundSize
                background.position = position
                background.zPosition = Layer.Background3 - self.zPosition
                background.xScale = scale
                backgroundTwo.addChild(background)
            }
        }
        
        // To center all the images, move the background nodes out to the left half the distance
        let offset = CGPoint(x: backgroundSize.width * CGFloat(gridCount) * -0.5,
                             y: backgroundSize.height * CGFloat(gridCount) * -0.5)
        backgroundOne.position = offset
        backgroundTwo.position = offset
        
        addChild(backgroundOne)
        addChild(backgroundTwo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Score handler stuff
//    func handleScore(name: String) {
//        playerLeftHUD.handleScore(name: name)
//    }
    
}
