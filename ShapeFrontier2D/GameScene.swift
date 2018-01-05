//
//  GameScene.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit


struct Layer {
    static let Background1: CGFloat = -5
    static let Background2: CGFloat = -4
    static let Background3: CGFloat = -3
    static let Overlay: CGFloat = 11
    static let UI: CGFloat = 10
    static let Powerup: CGFloat = 8
    static let Player: CGFloat = 9
    static let PlayerBullets: CGFloat = 6
    static let Enemies: CGFloat = 5
    static let Asteroids: CGFloat = 1
    static let EnemyBullets: CGFloat = 7
}

struct CollisionType {
    static let Nothing: UInt32 = 1
    static let Structure: UInt32 = 2
    static let StructureMissile: UInt32 = 4
    static let Construction: UInt32 = 8
    static let Enemy: UInt32 = 16
    static let EnemyMissile: UInt32 = 32
    static let Asteroid: UInt32 = 64
    static let Ground: UInt32 = 128
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    // Construction Mode
    var toBuild : Structure!
    var buildingImpedments : [Entity] = []
    var isBuilding = false
    var isValidSpot = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // Set up game and all it's goodness
        setupGame()
        
		// Pinch to zoom gesture recognizer
		let pinch : UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
		view.addGestureRecognizer(pinch)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchedNodes = nodes(at: t.location(in: self))
            
            PlayerHUDHandler.shared.buttonPressedDown(touchedNodes: touchedNodes, touchedLocation: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let translationInScene = touch!.location(in: self) - touch!.previousLocation(in: self)
        
        if !isBuilding {
            PlayerHUDHandler.shared.cameraMoved(dPoint: translationInScene)
        }
        else {
            updateConstructionMode(translation: translationInScene)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isBuilding {
            endConstructionMode()
        }
        else {
            for t in touches {
                let touchedNodes = nodes(at: t.location(in: self))
                PlayerHUDHandler.shared.buttonPressedUp(touchedNodes: touchedNodes, touchedLocation: t.location(in: self))
            }
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if isBuilding {
            
            if buildingImpedments.count == 0 {
                isValidSpot = true
            }
            else {
                isValidSpot = false
            }
            
        }
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            print("test1")
            return
        }
        
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        let nameA = bodyA?.name
        let nameB = bodyB?.name
        print("Name A: \(nameA), name B: \(nameB)")
        
        if nameA == nil || nameB == nil {
            return
        }
        
        if (nameA?.contains("UnderConstruction"))! {
            print("isNotValid")
            buildingImpedments.append(bodyA as! Entity)
        }
        else if (nameB?.contains("UnderConstruction"))! {
            print("isNotValid")
            buildingImpedments.append(bodyB as! Entity)
        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == nil || contact.bodyB.node == nil {
            return
        }
        
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        let nameA = bodyA?.name
        let nameB = bodyB?.name
        print("Name A: \(nameA), name B: \(nameB)")
        
        if nameA == nil || nameB == nil {
            return
        }
        
        if (nameA?.contains("UnderConstruction"))! {
            print("isValid")
            removeFromImpediments(entity: bodyA as! Entity)
        }
        else if (nameB?.contains("UnderConstruction"))! {
            print("isValid")
            removeFromImpediments(entity: bodyB as! Entity)
        }
        
    }
    
    /*
 
    Construction Actions
 
    */
    
    func startConstructionMode(structure: Structure) {
        toBuild = structure
        toBuild.position.y += sceneHeight * 0.2 * PlayerHUDHandler.shared.playerCamera.yScale
        
        addChild(toBuild)
        
        isBuilding = true
        
    }
    
    func updateConstructionMode(translation: CGPoint) {
        toBuild.position = toBuild.position + translation
        
        if isValidSpot {
            let color = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.0)
            toBuild.run(color)
        }
        else {
            let color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            toBuild.run(color)
        }
        
        //let overlay = SKSpriteNode(texture: , size: toBuild.size)
        
    }
    
    func endConstructionMode() {
        if isValidSpot {
            let color = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.0)
            toBuild.run(color)
            
            // Made it
            for _ in 0...16 {
                toBuild.name?.removeLast()
            }
            toBuild.isDisable = false
            
            
        }
        else {
            toBuild.removeFromParent()
        }
        
        isBuilding = false
        toBuild = nil
        isValidSpot = true
        
    }
    
    func removeFromImpediments(entity: Entity) {
        for i in 0..<buildingImpedments.count {
            if buildingImpedments[i].isEqual(entity) {
                buildingImpedments.remove(at: i)
                print("removed")
                return
            }
        }
    }
    
    /*
     
     UI ACTIONS!
     
     Pause Game
     Restart Game
     Clear Game
     
     */
    
    func pauseUnpause() -> Bool {
        self.isPaused = !self.isPaused
        return self.isPaused
    }
    
    func restartGame() {
        clearGame()
        PlayerHUDHandler.shared.resetHUD()
        
        let _ = pauseUnpause()
    }
    
    func clearGame() {
        
    }
    
    /*
 
     Game Setup Stuff
     
     Set Up Game
 
    */
    
    func setupGame() {
        // Add and create the camera
        let camera = PlayerHUDHandler.shared.setupHUD()
        addChild(camera)
        self.camera = camera
        
        // Setup asteroids
        let cluster = AsteroidManager.shared.createAsteroidCluster(atPoint: camera.position, mineralCap: 10000)
        addChild(cluster)
//        for asteroid in cluster.children {
//            asteroids.append(asteroid as! Asteroid)
//        }
    }
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        
        // Don't let the map get too small or too big:
        
        PlayerHUDHandler.shared.zoom(scale: sender.scale)
        sender.scale = 1.0
        
    }
    
}
