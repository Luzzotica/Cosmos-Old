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
    static let Overlay: CGFloat = 25
    static let UI: CGFloat = 20
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
    
    var enemies : [GKEntity] = []
//    var graphs = [String : GKGraph]()
    
//    private var lastUpdateTime : TimeInterval = 0
    
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
    var isBuilding = false
    var isValidSpot = false
    var touchMoved = false
    
    var connection_length : CGFloat = sceneWidth * 0.225
    
    // Asteroids
    var asteroidCluster = SKNode()
    
    // MARK: - Tick Variables
    let tick_speed : TimeInterval = 0.5
    var tick_last : TimeInterval = 0.0
    
    // Mineral variables
    var minerals_current : Int = 10000
    
    func power_add(toAdd: Int)
    {
        player_powerCurrent += toAdd
//        print("Current power is \(power_current)")
        if player_powerCurrent > player_powerCapacity
        {
            player_powerCurrent = player_powerCapacity
        }
    }
    
    func power_use(amount: Int, deficit: Int) {
        // Subtract energy from global power
        player_powerCurrent -= amount
//        print("Current power is \(power_current)")
        
        // If there was a deficit, we find other reactors
        if deficit != -1 {
            // Store the deficit
            var deficit_curr = deficit

            // While it's greater than 0, we want to keep looking for reactors with energy
            while deficit_curr > 0 {
                
                let reactor = power_findPowerSourceWithPower()
                
                if reactor != nil {
                    reactor!.power_current -= deficit_curr
                    // Set the deficit to whatever the reactors power now is
                    deficit_curr = reactor!.power_current
                    
                    // If the deficit is still less than 0, then we want to set the reactors power to 0
                    // Continue with the while loop
                    if deficit_curr < 0 {
                        reactor!.power_current = 0
                        deficit_curr *= -1
                    }
                }
                else {
                    print("This was impossible. Do something about it. Now.")
                    deficit_curr = 0
                }
            }
        }
    }
    
    func power_findPowerSourceWithPower() -> Supplier? {
        for reactor in player_suppliers {
            if reactor.power_current > 0 {
                return reactor
            }
        }
        
        return nil
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        
        // Set up game and all it's goodness
        setupGame()
        
        let enemies = EnemyHandler.shared.spawnWave()
        addChild(enemies[0])
        
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
            print("TOUCH WAS MOVED")
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
        if currentTime - tick_last > tick_speed {
            tick_last = currentTime
            tick()
        }
        
        // Update player hud instantly
        PlayerHUD.shared.updateHUD()
        
        if isBuilding && toBuild != nil {
            // If building, update validity based on impeding objects and mineral count
            // And change color based on current location validity
            var color: SKAction
            // Check impediments
//            print(toBuild!.physicsBody!.allContactedBodies().count)
            if toBuild!.physicsBody!.allContactedBodies().count > 0
            {
                isValidSpot = false
                color = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.0)
            }
                // Check minerals
            else if toBuild!.constructionCost > minerals_current {
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
        
        // Enemy updating
        EnemyHandler.shared.update(currentTime)
        
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
    
    /*
 
    Construction Actions
 
    */
    
    func startConstructionMode(structure: Structure) {
        toBuild = structure
        toBuild!.position.y += sceneHeight * 0.2 * PlayerHUD.shared.yScale
        
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
        toBuild?.position = toBuild!.position + translation
        
        // Get structures we can draw to
        let drawTo = searchStructuresInRange(isSupplier: toBuild!.isSupplier)
        
        if toBuild!.isSupplier {
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
            for _ in 0...17 {
                toBuild?.name?.removeLast()
            }
            
            // Make him be a structure
            toBuild!.physicsBody?.categoryBitMask = CollisionType.Structure
            
            // Make him enabled
            toBuild?.isDisabled = false
            
            // Remove his range indicator
            for i in stride(from: toBuild!.children.count - 1, through: 0, by: -1) {
                if toBuild?.children[i].name == "rangeIndicator" {
                    toBuild?.children[i].removeFromParent()
                }
            }
            
            // Mineral Cost
            minerals_current -= toBuild!.constructionCost
            PlayerHUD.shared.update_resources()
            
            // Finish Construction
            toBuild!.didFinishConstruction()
            
            // Add everything to structures
            player_structures.append(toBuild!)
            
            // If this building was a reactor, add it to the players reactors
            // We will add batteries later...
            if toBuild! is Reactor {
                player_suppliers.append(toBuild as! Supplier)
            }
            // If it was a turret, add it to player's turrets
            if toBuild! is Turret {
                player_turrets.append(toBuild as! Turret)
            }
            // If it was a miner, add it to player's miners
            if toBuild! is Miner {
                player_miners.append(toBuild as! Miner)
            }
            
        }
        else {
            toBuild?.removeFromParent()
        }
        
        // Reset the building, connecting, and validity
        toBuild = nil
        isValidSpot = true
        isBuilding = false
    }
    
    func searchStructuresInRange(isSupplier: Bool) -> [Structure] {
        var inRange : [Structure] = []
        var currentRange : CGFloat = sceneWidth
        
        for targetStructure in player_structures {
            // If he is a supplier, he can link to all people in range
            if isSupplier {
                if withinDistance(point1: targetStructure.position,
                                  point2: toBuild!.position,
                                  distance: connection_length).0 {
                    if !targetStructure.isSupplier && targetStructure.connection_powerLine == nil {
                        inRange.append(targetStructure)
                    }
                    else if targetStructure.isSupplier {
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
    
    func structureDied(structure: Structure)
    {
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
        
        // Setup asteroids
        asteroidCluster = AsteroidManager.shared.createAsteroidCluster(atPoint: playerCamera!.position, mineralCap: 30000)
        addChild(asteroidCluster)
        
        // Start up the background music
        SoundHandler.shared.playBackgroundMusic()
    }
    
    @objc func zoom(_ sender: UIPinchGestureRecognizer) {
        
        // Don't let the map get too small or too big:
        
        PlayerHUD.shared.zoom(scale: sender.scale)
        sender.scale = 1.0
        
    }
    
}
