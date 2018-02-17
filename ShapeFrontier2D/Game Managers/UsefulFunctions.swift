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

func getDistance(point1: CGPoint, point2: CGPoint) -> CGFloat {
    let x = point1.x - point2.x
    let y = point1.y - point2.y
    return sqrt((x * x) + (y * y))
}

func withinDistance(point1: CGPoint, point2: CGPoint, distance: CGFloat) -> (Bool, CGFloat?) {
    let actual = getDistance(point1: point1, point2: point2)
    if actual > distance {
        return (false, nil)
    }
    else {
        return (true, actual)
    }
}
