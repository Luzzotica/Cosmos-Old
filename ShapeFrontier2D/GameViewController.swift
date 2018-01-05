//
//  GameViewController.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var gameScene : GameScene!

// game scene variables
var sceneWidth : CGFloat!
var sceneHeight : CGFloat!
var sceneView : SKView!

// Font size for in game text
var fontSizeN : CGFloat! // Normal Font Size
var fontSizeT : CGFloat! // Title Font Size
var fontSizeS : CGFloat! // Small Font Size
let fontStyleN = "Menlo-Regular" // Normal font type
let fontStyleT = "Menlo-Bold" // Title font type

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up screen size
        sceneWidth = view.bounds.size.width
        sceneHeight = view.bounds.size.height
        
		
		// Set up fonts
		setupFonts()
		
        // Set up game scene
        setupSceneView()
    }
    
    // Setup all the things
    func setupFonts() {
		fontSizeS = sceneHeight * 0.03
        fontSizeN = sceneHeight * 0.04
        fontSizeT = sceneHeight * 0.08
    }
    
    func setupSceneView() {
        let vSize = CGRect(x: 0.0,
                           y: 0.0,
                           width: sceneWidth,
                           height: sceneHeight)
        sceneView = SKView(frame: vSize)
        
        gameScene = GameScene(size: CGSize(width: sceneWidth, height: sceneHeight))
        sceneView.presentScene(gameScene)
        
        sceneView.ignoresSiblingOrder = true
        
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        self.view.addSubview(sceneView)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
