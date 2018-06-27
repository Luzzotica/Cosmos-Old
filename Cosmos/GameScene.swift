//
//  GameScene.swift
//  Cosmos
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Construction Mode variables
    var toBuild : Structure?
    var toBuildSprite : SKSpriteNode?
    var toBuildNode : SKNode?
    var isBuilding = false
    var isValidSpot = false
    var touchMoved = false
    
    // Asteroids
    var asteroidCluster : [Asteroid] = []
    
    // Tick Variables
    let tick_speed : TimeInterval = 0.5
    var tick_last : TimeInterval = 0.0
    
    // Update time!
    var lastUpdateTime : TimeInterval = 0
    
    //Touch Variables
    var touches_disabled_timer : TimeInterval = 0
    
    override func didMove(to view: SKView) {
        // Add some teams and players
        let player = PlayerManager.shared.createClientPlayer()
        let _ = TeamManager.shared.createNewTeam()
        
        // Set up game and all it's goodness
        setupGame()
        
        // Add the first player reactor
        let firstReactor = Reactor(playerID: player.playerID)
        
        // Move the reactor to the center of the screen
        firstReactor.component(ofType: SpriteComponent.self)?.node.position = PlayerManager.shared.clientPlayer.playerHUD!.position
        
        // Update the positioning of the move component
        if let moveComponent = firstReactor.component(ofType: MoveComponent.self),
            let spriteComponent = firstReactor.component(ofType: SpriteComponent.self) {
            moveComponent.position = float2(spriteComponent.node.position)
        }
        firstReactor.didFinishConstruction()
        
        // Add everything to structures
//        player_structures.append(firstReactor)
//        player_suppliers.append(firstReactor)
        EntityManager.shared.add(firstReactor)
        
        // Pinch to zoom gesture recognizer
        let pinch : UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
        view.addGestureRecognizer(pinch)
    }
    
    func spawnWave() {
        let enemies = EnemyManager.shared.spawnWave()
        
        for enemy in enemies {
            EntityManager.shared.add(enemy)
        }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches_disabled_timer <= 0 {
            touches_disabled_timer = GameValues.TouchDelay
        }
        else {
            return
        }
        
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
        
        //Handle touch disabling timer
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let delta = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        if touches_disabled_timer > 0
        {
            touches_disabled_timer -= delta
        }
        
        // Update player hud instantly
        PlayerHUD.shared.updateHUD()
        
        // Handle the building functions
        if isBuilding && toBuild != nil {
            // If building, update validity based on impeding objects and mineral count
            // And change color based on current location validity
            var color: SKAction
            // Check impediments
            if toBuildNode!.physicsBody!.allContactedBodies().count > 0 {
//                print("Colliding")
                isValidSpot = false
                color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            }
                // Check minerals
            else if toBuild!.constructionCost >
                PlayerManager.shared.players[toBuild!.playerID]!.getCurrentMinerals() {
//                print("no minerals")
                isValidSpot = false
                color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            }
            else
            {
                isValidSpot = true
                color = SKAction.colorize(with: .green, colorBlendFactor: 1.0, duration: 0.0)
            }
            
            toBuildSprite!.run(color)
        }
        
        // Need to pass in delta, not the current time!
        EntityManager.shared.update(delta)
    }
    
    func tick() {
//        for supplier in player_suppliers {
//            supplier.tick()
//        }
//        for turret in player_turrets {
//            turret.tick()
//        }
//        for miner in player_miners {
//            miner.tick()
//        }
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
//        player_structures.remove(at: player_structures.index(of: structure)!)
//        if structure is Miner
//        {
//            player_miners.remove(at: player_miners.index(of: structure as! Miner)!)
//        }
//        else if structure is Reactor
//        {
//            player_suppliers.remove(at: player_suppliers.index(of: structure as! Reactor)!)
//        }
//        else if structure is Turret
//        {
//            player_turrets.remove(at: player_turrets.index(of: structure as! Turret)!)
//        }
//        else
//        {
//            print("It's a node!")
//        }
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
//        player_structures.removeAll()
    }
    
    // MARK: - Game Setup
    
    func setupGame() {
        // Setup world physics
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // Get the HUD from the main player
        let playerCamera = PlayerHUD.shared
        addChild(playerCamera)
        camera = playerCamera

        // Configure the players
        
        // Setup asteroids
        asteroidCluster = AsteroidManager.shared.createAsteroidCluster(atPoint: playerCamera.position, mineralCap: 100000)
        for asteroid in asteroidCluster {
            EntityManager.shared.add(asteroid)
        }
        
        // Start up the background music
        SoundHandler.shared.playBackgroundMusic()
        
        // Set the background to a nice dark blue
        backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    }
    
    // MARK: - UI Actions
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        
        PlayerHUD.shared.zoom(scale: sender.scale)
        sender.scale = 1.0
        
    }
    
}
