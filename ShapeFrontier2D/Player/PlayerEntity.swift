//
//  PlayerEntity.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/30/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerEntity : GKEntity {
    
    var playerHUD : PlayerHUD
    
    var player : Int
    var enemies : [Int]
    var team : Team?
    
    init(playerHUD: PlayerHUD, player: Int, enemies: [Int]) {
        self.playerHUD = playerHUD
        
        self.player = player
        self.enemies = enemies
        
        super.init()
        
        self.playerHUD.playerEntity = self
    }
    
    func enemyDied(_ enemy: GKEntity) {
        playerHUD.enemyDied(enemy)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
