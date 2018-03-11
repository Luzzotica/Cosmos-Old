//
//  GameScene_Structs.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 3/10/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

struct Layer {
    static let Background1: CGFloat = -5
    static let Background2: CGFloat = -4
    static let Background3: CGFloat = -3
    static let Overlay: CGFloat = 150
    static let UI: CGFloat = 100
    static let Powerup: CGFloat = 8
    static let Player: CGFloat = 25
    static let PlayerBullets: CGFloat = 6
    static let Enemies: CGFloat = 50
    static let Asteroids: CGFloat = 5
    static let EnemyBullets: CGFloat = 55
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
