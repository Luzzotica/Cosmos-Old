//
//  UsefulFunctions.swift
//  ShapeFrontier2D
//
//  Created by Sterling Long on 1/4/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import SpriteKit

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += ( left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func withinDistance(point1: CGPoint, point2: CGPoint, distance: CGFloat) -> Bool {
    let actual = hypot(point1.x - point2.x, point1.y - point2.y)
    if actual > distance {
        return false
    }
    else {
        return true
    }
}
