//
//  GameEntity.swift
//  Cosmos
//
//  Created by Sterling Long on 7/3/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import GameplayKit

protocol GameplayEntity
{
    
    var playerID: Int { get set }
    var isDisabled: Bool { get set }
    
    func select()
    func deselect()
    
    func didDied()
    
}
