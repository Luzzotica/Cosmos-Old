//
//  SoundHandler_BackgroundMusic.swift
//  Cosmos
//
//  Created by Sterling Long on 1/22/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import AVFoundation

// This extension handles background music
extension SoundHandler {
    
    func prepareBackgroundMusic() {
        let music : [String] = ["Menu Ambience1"]
        
        for song in music {
            // Get the file and URL for the path
            let soundFile = Bundle.main.path(forResource: song, ofType: ".mp3")!
            let path = URL(fileURLWithPath: soundFile)
            
            // Create background music node
            let backgroundPlayer = try! AVAudioPlayer(contentsOf: path)
            
            // Make sure his delegate is the Sound Handler so he can detect when the song finishes
            backgroundPlayer.delegate = self
            
            backgroundPlayers.append(backgroundPlayer)
        }
    }
    
    func playBackgroundMusic() {
        // Plays the current
        backgroundPlayers[backgroundPlayerCurrent].setVolume(volumeCurr_music, fadeDuration: 0.0)
        backgroundPlayers[backgroundPlayerCurrent].prepareToPlay()
        backgroundPlayers[backgroundPlayerCurrent].play()
    }
    
}
