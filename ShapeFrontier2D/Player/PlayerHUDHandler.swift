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


class PlayerHUDHandler : NSObject, CollectionNodeDelegate, CollectionNodeDataSource {
    static let shared = PlayerHUDHandler()
    
    let playerButtonHandler = PlayerButtonHandler()
    
    var playerCamera : SKCameraNode!
	
	// Bottom HUD
	private var collectionNode: CollectionNode!
	private var buildings:[String] = ["one", "two", "three"]
	
    
    func setupHUD() -> SKCameraNode {
        // Create a camera node and shift it to center the scene
        // All UI will be attached to it
        playerCamera = SKCameraNode()
        playerCamera.position.x = sceneWidth * 0.5
        playerCamera.position.y = sceneHeight * 0.5
        playerCamera.zPosition = Layer.UI
        playerCamera.name = "mainCamera"
        
        // setup other game handlers and all their glorious things, add them to the camera
		
		
		let hudContainer = UIView(frame: CGRect(x: 0, y: sceneHeight - 76, width: sceneWidth, height: 76))
		hudContainer.backgroundColor = .clear
//		sceneView.addSubview(hudContainer)
//		sceneView.sendSubview(toBack: hudContainer)
		sceneView.insertSubview(hudContainer, at: 0)
		
		collectionNode = CollectionNode(at: hudContainer)
		
		collectionNode.dataSource = self
		collectionNode.delegate = self
		
		// TODO: - Fix Magic Numbers
		collectionNode.position = CGPoint(x:  -sceneWidth / 2 + 30, y: -(sceneHeight / 2) + 30)
		playerCamera.addChild(collectionNode)
		
		// The bottom 76 points of the screen
//		let nodeSideSize = 60
//		scrollView = SwiftySKScrollView(frame: CGRect(x: 0, y: gameScene.size.height - 76, width: gameScene.size.width, height: 76), moveableNode: moveableNode, direction: .horizontal)
//
//		//        scrollView?.contentSize = CGSize(width: CGFloat(buildings.count * (nodeSideSize + 8)), height: scrollView!.frame.height)
//		scrollView?.contentSize = CGSize(width: scrollView!.frame.size.width * 5, height: scrollView!.frame.height)
//
//		gameScene.view?.addSubview(scrollView!)
//		scrollView?.setContentOffset(CGPoint(x: 0 + scrollView!.frame.width * 4, y: 0), animated: true)
//
//
//		//        Step 4: - Add sprites for each page in the scrollView to make positioning your actual stuff later on much easier
//
//		guard let scrollView = scrollView else { return playerCamera } // unwrap  optional
//
//
//		var xPos: CGFloat = 0.0
//		let width = scrollView.frame.width / 2
//		let height = scrollView.frame.size.height
//		let yPos = scrollView.frame.size.height / 2
//
//		let colors = [UIColor.orange, UIColor.green, UIColor.blue]
//		for i in 0...10 {
//			let color = colors[i % 3]
//
//			let pageScrollView = SKSpriteNode(color: color, size: CGSize(width: width, height: height))
//			pageScrollView.position = CGPoint(x: xPos - (width / 2), y: yPos)
//			moveableNode.addChild(pageScrollView)
//
//			// Add sprites / labels
//			let sprite1 = SKSpriteNode(color: .red, size: CGSize(width: nodeSideSize, height: nodeSideSize))
//			sprite1.position = CGPoint(x: 0, y: 0)
//			pageScrollView.addChild(sprite1)
//
//			let sprite2 = SKSpriteNode(color: .red, size: CGSize(width: nodeSideSize, height: nodeSideSize))
//			sprite2.position = CGPoint(x: sprite1.position.x + (sprite2.size.width * 1.5), y: sprite1.position.y)
//			sprite1.addChild(sprite2)
//
//			xPos += width
//		}
		
        return playerCamera
    }
    
    func resetHUD() {
        
    }
	
	
	func update(_ currentTime: TimeInterval) {
		collectionNode.update(currentTime)
	}
    
    func cameraMoved(dx: CGFloat, dy: CGFloat) {
        playerCamera.position.x -= dx
        playerCamera.position.y -= dy
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
    
    //
    
    func buttonPressed(touchedNodes: [SKNode]) {
        playerButtonHandler.buttonPressed(touchedNodes)
    }
    
    // Score handler stuff
//    func handleScore(name: String) {
//        playerLeftHUD.handleScore(name: name)
//    }
	
	
	// MARK: - CollectionNodeDataSource
	
	func numberOfItems() -> Int {
		return buildings.count
	}
	
	func collectionNode(_ collection: CollectionNode, itemFor index: Index) -> CollectionNodeItem {
		//create and configure items
		let item = BuildingItem()
		item.building = self.buildings[index]
		
		return item
	}
	
	
	// MARK: - CollectionNodeDelegate
	func collectionNode(_ collectionNode: CollectionNode, didShowItemAt index: Index) {
		let growAction = SKAction.scale(to: 1.3, duration: 0.15)
		let shrinkAction = SKAction.scale(to: 1, duration: 0.15)
		
//		collectionNode.item(at: index).run(growAction)
//		collectionNode.children.filter{ emojiCollection.children.index(of: $0) != index }.forEach{ $0.run(shrinkAction) }
	}
	
	func collectionNode(_ collectionNode: CollectionNode, didSelectItem item: CollectionNodeItem, at index: Index) {
		print("selected \(item.name ?? "noNameItem") at index \(index)")
	}
	
	
	func updatePositionForSelectedNode(selectedNode: SKSpriteNode, panGesture: UIPanGestureRecognizer) {
		if selectedNode.parent == nil {
			gameScene.addChild(selectedNode)
		}
		
		let location = panGesture.location(in: gameScene.view)
		selectedNode.position = CGPoint(x: location.x, y: -location.y + sceneHeight)
	}
}
