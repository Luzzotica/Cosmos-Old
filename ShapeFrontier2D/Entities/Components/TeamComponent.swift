//
//  TeamComponent.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class TeamComponent: GKComponent {
  
    var teamID : String
  
    init(teamID: String) {
        self.teamID = teamID
        super.init()
    }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
