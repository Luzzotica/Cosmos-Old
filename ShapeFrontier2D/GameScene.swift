//
//  GameScene.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Player camera
    var playerCamera: SKCameraNode?
    
    // Player structures in game
    var player_Clusters : [Structure] = []
    var player_structures : [Structure] = []
    
    // Priority structures
    var player_suppliers : [Supplier] = []
    var player_turrets : [Turret] = []
    var player_miners : [Miner] = []
    
    // Power Variables
    var player_powerCurrent : Int = 0
    var player_powerCapacity : Int = 0
    
    // Construction Mode variables
    var toBuild : Structure?
    var toBuildSprite : SKSpriteNode?
    var toBuildNode : SKNode?
    var isBuilding = false
    var isValidSpot = false
    var touchMoved = false
    
    var connection_length : CGFloat = sceneWidth * 0.225
    
    // Asteroids
    var asteroidCluster : [Asteroid] = []
    
    // Tick Variables
    let tick_speed : TimeInterval = 0.5
    var tick_last : TimeInterval = 0.0
    
    // Mineral variables
    var minerals_current : Int = 10000
    
    // Update time!
    var lastUpdateTime : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // Set up game and all it's goodness
        setupGame()
        
        // Add the first player reactor
        let firstReactor = Reactor(texture: Structures.reactorLevel1, team: .team1)
        firstReactor.didFinishConstruction()
        // Move the reactor to the center of the screen
        firstReactor.component(ofType: SpriteComponent.self)?.node.position = playerCamera!.position
        
        // Add everything to structures
        player_structures.append(firstReactor)
        player_suppliers.append(firstReactor)
        EntityManager.shared.add(firstReactor)
        
        let enemies = EnemyManager.shared.spawnWave()

        for enemy in enemies {
            EntityManager.shared.add(enemy)
        }
        
        // Pinch to zoom gesture recognizer
        let pinch : UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
        view.addGestureRecognizer(pinch)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchedNodes = nodes(at: t.location(in: self))
            
            PlayerHUD.shared.buttonPressedDown(touchedNodes, location: t.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        let translationInScene = touch!.location(in: self) - touch!.previousLocation(in: self)
        
        if !touchMoved && getDistance(point1: touch!.location(in: self),
                                      point2: touch!.previousLocation(in: self)) > sceneWidth * 0.005 {
            touchMoved = true
//            print("TOUCH WAS MOVED")
        }
        
        if !isBuilding {
            // If we aren't building, move camera
            PlayerHUD.shared.cameraMoved(dPoint: translationInScene)
        }
        else {
            // Otherwise, update the construction
            updateConstruction(translation: translationInScene)
        }
    }
    
    SWAGGGGGGWAGGSGSGWSWAG!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isBuilding {
            // If building, end construction mode on touchup
            endConstructionMode()
        }
        else {
            // Otherwise, handle button presses
            if !touchMoved {
                for t in touches {
                    let touchedNodes = nodes(at: t.location(in: self))
                    PlayerHUD.shared.buttonPressedUp(touchedNodes, location: t.location(in: self))
                }
            }
        }
        touchMoved = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Handle the tick for all the entities
        if currentTime - tick_last > tick_speed {
            tick_last = currentTime
            tick()
        }
        
        // Update player hud instantly
        PlayerHUD.shared.updateHUD()
        
        // Handle the building functions
        if isBuilding && toBuild != nil {
            // If building, update validity based on impeding objects and mineral count
            // And change color based on current location validity
            var color: SKAction
            // Check impediments
            if toBuild!.mySprite.physicsBody!.allContactedBodies().count > 0
            {
//                print("Colliding")
                isValidSpot = false
                color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            }
                // Check minerals
            else if toBuild!.constructionCost > minerals_current {
//                print("no minerals")
                isValidSpot = false
                color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            }
            else
            {
                isValidSpot = true
                color = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.0)
            }
            
            toBuild?.mySprite.run(color)
        }
        
        // Enemy updating
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        // Need to pass in delta, not the current time!
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        EntityManager.shared.update(delta)
    }
    
    func tick() {
        for supplier in player_suppliers {
            supplier.tick()
        }
        for turret in player_turrets {
            turret.tick()
        }
        for miner in player_miners {
            miner.tick()
        }
        PlayerHUD.shared.update_resources()
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
    }
    
    func structureDied(structure: Structure) {
        player_structures.remove(at: player_structures.index(of: structure)!)
        if structure is Miner
        {
            player_miners.remove(at: player_miners.index(of: structure as! Miner)!)
        }
        else if structure is Reactor
        {
            player_suppliers.remove(at: player_suppliers.index(of: structure as! Reactor)!)
        }
        else if structure is Turret
        {
            player_turrets.remove(at: player_turrets.index(of: structure as! Turret)!)
        }
        else
        {
            print("It's a node!")
        }
    }
    
    // Mark: - UI ACTIONS
    
    /*
     
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
        PlayerHUD.shared.resetHUD()
        
        let _ = pauseUnpause()
    }
    
    func clearGame() {
        player_structures.removeAll()
    }
    
    /*
 
     Game Setup Stuff
     
     Set Up Game
 
    */
    
    func setupGame() {
        // Add and create the camera
        playerCamera = PlayerHUD.shared
        addChild(playerCamera!)
        camera = playerCamera
        
        // Add the player
        let player = PlayerEntity(playerHUD: PlayerHUD.shared, player: 1, enemies: [666])
        EntityManager.shared.addPlayer(player)
        
        // Setup asteroids
        asteroidCluster = AsteroidManager.shared.createAsteroidCluster(atPoint: playerCamera!.position, mineralCap: 100000)
        for asteroid in asteroidCluster {
            EntityManager.shared.add(asteroid)
        }
        
        // Start up the background music
        SoundHandler.shared.playBackgroundMusic()
        
        // Set the background to a nice dark blue
        backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    }
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        
        PlayerHUD.shared.zoom(scale: sender.scale)
        sender.scale = 1.0
        
    }
    
}
