//
//  GameScene.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import SpriteKit
import GameplayKit

import SwiftySKScrollView


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
    static let Blocks: CGFloat = 4
    static let EnemyBullets: CGFloat = 7
}

struct CollisionType {
    static let Nothing: UInt32 = 1
    static let Player: UInt32 = 2
    static let PlayerBullet: UInt32 = 4
    static let Enemy: UInt32 = 8
    static let Blocks: UInt32 = 16
    static let Decoration: UInt32 = 32
    static let Ground: UInt32 = 64
    static let Powerup: UInt32 = 128
    static let AllObjects: UInt32 = PlayerBullet | Enemy | Blocks | Powerup
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
	
	private var scrollView: SwiftySKScrollView?
	private let moveableNode = SKNode()
	
	private var buildings:[String] = []
	
	
	
	// MARK: - Setup
    
    let asteroidManager = AsteroidManager()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let touchedNodes = nodes(at: t.location(in: self))
            
            PlayerHUDHandler.shared.buttonPressed(touchedNodes: touchedNodes)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
	
	
	override func didMove(to view: SKView) {
		addChild(moveableNode)
		
		// The bottom 76 points of the screen
		let nodeSideSize = 60
		scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: size.height - 76, width: size.width, height: 76), moveableNode: moveableNode, direction: .horizontal)
		
//		scrollView?.contentSize = CGSize(width: CGFloat(buildings.count * (nodeSideSize + 8)), height: scrollView!.frame.height)
		scrollView?.contentSize = CGSize(width: scrollView!.frame.size.width * 3, height: scrollView!.frame.height)
		
		self.view?.addSubview(scrollView!)
		scrollView?.setContentOffset(CGPoint(x: 0 + scrollView!.frame.width * 2, y: 0), animated: true)
		
		
//		Step 4: - Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
		
		guard let scrollView = scrollView else { return } // unwrap  optional
		
		let page1ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
		page1ScrollView.position = CGPoint(x: frame.midX - (scrollView.frame.width * 2), y: frame.midY)
		moveableNode.addChild(page1ScrollView)
		
		let page2ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
		page2ScrollView.position = CGPoint(x: frame.midX - (scrollView.frame.width), y: frame.midY)
		moveableNode.addChild(page2ScrollView)
		
		let page3ScrollView = SKSpriteNode(color: .clear, size: CGSize(width: scrollView.frame.width, height: scrollView.frame.size.height))
		page3ScrollView.zPosition = -1
		page3ScrollView.position = CGPoint(x: frame.midX, y: frame.midY)
		moveableNode.addChild(page3ScrollView)
		
		
//		Step 5: Add your sprites, labels etc. Because you will add them to the above sprites you can position them as usual which is why its much easier to do Step 4 first.
		
		/// Test sprites page 1
		let sprite1Page1 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
		sprite1Page1.position = CGPoint(x: 0, y: 0)
		page1ScrollView.addChild(sprite1Page1)
		
		let sprite2Page1 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
		sprite2Page1.position = CGPoint(x: sprite1Page1.position.x + (sprite2Page1.size.width * 1.5), y: sprite1Page1.position.y)
		sprite1Page1.addChild(sprite2Page1)
		
		/// Test sprites page 2
		let sprite1Page2 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
		sprite1Page2.position = CGPoint(x: 0, y: 0)
		page2ScrollView.addChild(sprite1Page2)
		
		let sprite2Page2 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
		sprite2Page2.position = CGPoint(x: sprite1Page2.position.x + (sprite2Page2.size.width * 1.5), y: sprite1Page2.position.y)
		sprite1Page2.addChild(sprite2Page2)
		
		/// Test sprites page 3
		let sprite1Page3 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
		sprite1Page3.position = CGPoint(x: 0, y: 0)
		page3ScrollView.addChild(sprite1Page3)
		
		let sprite2Page3 = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
		sprite2Page3.position = CGPoint(x: sprite1Page3.position.x + (sprite2Page3.size.width * 1.5), y: sprite1Page3.position.y)
		sprite1Page3.addChild(sprite2Page3)
	}
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
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
        let camera = PlayerHUDHandler.shared.setupHUD()
        addChild(camera)
        self.camera = camera
    }
}
