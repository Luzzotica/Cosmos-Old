//
//  SoundHandler.swift
//  Cosmos
//
//  Created by Sterling Long on 1/15/18.
//  Copyright © 2018 Sterling Long. All rights reserved.
//

import Foundation
import AVFoundation

class SoundHandler : NSObject, AVAudioPlayerDelegate {
    
    static let shared = SoundHandler()
    
    // Volume Controls
    var volumeMax_music : Float = 0.5
    var volumeCurr_music : Float = 0.5
    var volumeMax_sfx : Float = 1.0
    var volumeCurr_sfx : Float = 1.0
    
    // Background music players
    var backgroundPlayerCurrent = 0
    var backgroundPlayers : [AVAudioPlayer] = []
    
    // Basic audio players for any sound in the game
    var players : [URL:AVAudioPlayer] = [:]
    var duplicatePlayers : [AVAudioPlayer] = []
    
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        } catch let error as NSError {
            print("ERROR: \(error.description)")
        }
        
        prepareBackgroundMusic()
    }
    
    func playSoundFile(name: String, withVolume: Float = 1.0) {
        
        // Get the sound file path
        let soundFile = Bundle.main.path(forResource: name, ofType: ".wav")!
        let path = URL(fileURLWithPath: soundFile)
        
        // If the player exists in the dictionary, get it
        if let player = players[path] {
            
            if !player.isPlaying {
                player.setVolume(withVolume, fadeDuration: 0.0)
                player.prepareToPlay()
                player.play()
            }
            else {
                guard let duplicatePlayer = player.copy() as? AVAudioPlayer else { return }
                duplicatePlayer.delegate = self
                
                // Add him to the duplicates. He will delete himself after playing
                duplicatePlayers.append(duplicatePlayer)
                
                player.prepareToPlay()
                player.play()
            }
        }
            // Otherwise, make it
        else {
            do {
                // Create the player
                let player = try AVAudioPlayer(contentsOf: path)
                player.delegate = self
                
                player.prepareToPlay()
                player.play()
                
                // Create new path in the dictionary
                players[path] = player
            }
            catch {
                print("Couldn't Load Sound")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.setVolume(1.0, fadeDuration: 0.0)
        //Remove the duplicate player once it is done
        if let index = duplicatePlayers.index(of: player) {
            // If we were part of the sounds
            duplicatePlayers.remove(at: index)
        }
        
        // Loop the background music
        if let index = backgroundPlayers.index(of: player) {
            backgroundPlayerCurrent = (index + 1) % backgroundPlayers.count
            playBackgroundMusic()
        }
    }
    
    func stopAllSounds() {
        // Stop all sounds in the dictionary
        for (_, player) in players {
            if player.isPlaying {
                player.stop();
            }
        }
        
        // Stop all sounds in the duplicates array
        for player in duplicatePlayers {
            player.stop()
        }
        
        // Pause background music
        backgroundPlayers[backgroundPlayerCurrent].pause()
    }
    
    func resumeAllSounds() {
        backgroundPlayers[backgroundPlayerCurrent].play()
    }
    
}
