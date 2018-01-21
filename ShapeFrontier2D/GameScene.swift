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
    static let PowerLine: UInt32 = 16
    static let Enemy: UInt32 = 32
    static let EnemyMissile: UInt32 = 64
    static let Asteroid: UInt32 = 128
    static let Ground: UInt32 = 256
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    
    // Player structures in game
    var playerStructures : [Structure] = []
    
    // Construction Mode variables
    var toBuild : Structure?
    var isBuilding = false
    var isValidSpot = false
    
    var connection_length : CGFloat = sceneWidth * 0.225
    
    // MARK: - Setup
    let playerResourcesManager = PlayerResourcesHUD()
    
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
            // If we aren't building, move camera
            PlayerHUDHandler.shared.cameraMoved(dPoint: translationInScene)
        }
        else {
            // Otherwise, update the construction
            updateConstruction(translation: translationInScene)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isBuilding {
            // If building, end construction mode on touchup
            endConstructionMode()
        }
        else {
            // Otherwise, handle button presses
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
        
        if isBuilding && toBuild != nil {
            // If building, update validity based on impeding objects
            // And change color based on current location validity
            var color: SKAction
            if toBuild!.physicsBody!.allContactedBodies().count > 0
            {
                isValidSpot = false
                color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            }
            else
            {
                isValidSpot = true
                color = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.0)
            }
            toBuild?.run(color)
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
            //print("test1")
            return
        }
        
        let bodyA = contact.bodyA.node
        let bodyB = contact.bodyB.node
        let nameA = bodyA?.name
        let nameB = bodyB?.name
        //print("Name A: \(nameA), name B: \(nameB)")
        
        if nameA == nil || nameB == nil {
            return
        }
        
        // If something enters into collision with the UnderConstruction, add it to impeding objects
        if (nameA?.contains("UnderConstruction"))! {
            //print("isNotValid")
            buildingImpedments.append(bodyA as! Entity)
        }
        else if (nameB?.contains("UnderConstruction"))! {
            //print("isNotValid")
            buildingImpedments.append(bodyB as! Entity)
        }
        
    }
    
    /*
 
    Construction Actions
 
    */
    
    func startConstructionMode(structure: Structure) {
        toBuild = structure
        toBuild!.position.y += sceneHeight * 0.2 * PlayerHUDHandler.shared.playerCamera.yScale
        
        // Add connection range
        toBuild?.addChild(UIHandler.shared.createRangeIndicator(
            range: connection_length,
            color: .yellow))
        
        // Add to game scene
        addChild(toBuild!)
        
        // Make sure the scene knows we are currently building
        isBuilding = true
        
    }
    
    func updateConstruction(translation: CGPoint) {
        // Move the structure
        toBuild?.position = (toBuild?.position)! + translation
        
        // Get structures we can draw to
        let drawTo = searchStructuresInRange(isSupplier: toBuild!.isSupplier)
        
        if toBuild!.isSupplier {
//            print(drawTo)
            let toBuildSupplier = toBuild as! Supplier
            for structures in drawTo {
                toBuildSupplier.connection_addTo(structure: structures)
            }
            
            toBuildSupplier.connection_updateLines()
        }
        else {
            //print(drawTo)
            if drawTo.count > 0 {
                toBuild?.connection_addTo(structure: drawTo[0])
            }
            toBuild?.connection_updateLines()
        }
        
        
    }
    
    func endConstructionMode() {
        if isValidSpot {
            // Turn him to normal color
            let color = SKAction.colorize(with: .white, colorBlendFactor: 1.0, duration: 0.0)
            toBuild?.run(color)
            
            // Made it, remove the name identifier
            for _ in 0...16 {
                toBuild?.name?.removeLast()
            }
            
            // Make him enabled
            toBuild?.isDisabled = false
            
            // Remove his range indicator
            for i in stride(from: toBuild!.children.count - 1, through: 0, by: -1) {
                if toBuild?.children[i].name == "rangeIndicator" {
                    toBuild?.children[i].removeFromParent()
                }
            }
            
            playerStructures.append(toBuild!)
        }
        else {
            toBuild?.removeFromParent()
        }
        
        // Reset the building, connecting, and validity
        buildingImpedments.removeAll()
        isBuilding = false
        toBuild = nil
        isValidSpot = true
        
    }
    
    func searchStructuresInRange(isSupplier: Bool) -> [Structure] {
        var inRange : [Structure] = []
        var currentRange : CGFloat = sceneWidth
        
        for targetStructure in playerStructures {
            // If he is a supplier, he can link to all people in range
            if isSupplier {
                if withinDistance(point1: targetStructure.position,
                                  point2: toBuild!.position,
                                  distance: connection_length).0 {
                    if !targetStructure.isSupplier && targetStructure.connection_master == nil {
                        inRange.append(targetStructure)
                    }
                    else {
                        inRange.append(targetStructure)
                    }
                    
                }
            }
                // Otherwise, get the closest supplier
            else if targetStructure.isSupplier {
                let values = withinDistance(point1: targetStructure.position,
                                            point2: toBuild!.position,
                                            distance: connection_length)
                if values.0 {
                    if currentRange > values.1! {
                        currentRange = values.1!
                        inRange.removeAll()
                        inRange.append(targetStructure)
                    }
                }
            }
        }
        
        return inRange
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
        playerStructures.removeAll()
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
        let cluster = AsteroidManager.shared.createAsteroidCluster(atPoint: camera.position, mineralCap: 5000)
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
