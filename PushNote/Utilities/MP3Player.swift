///
//  MP3Player.swift
//  MP3Player
//
//  Created by James Tyner on 7/17/15.
//  Copyright (c) 2015 James Tyner. All rights reserved.
//

import UIKit
import AVFoundation

class MP3Player: NSObject, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer?
    var currentTrackIndex = 0
    var tracks:[String] = [String]()
    override init(){
        
        super.init()
    }
    func queueTrack(_ data : Data){
        if (player != nil) {
            player = nil
        }
        
        do{
            
            player =  try AVAudioPlayer(data: data)
            player?.prepareToPlay()
            
        }catch _ {
            print("ERROR")
        }
    }
        
        func play() {
            if player?.isPlaying == false {
                player?.play()
            }
        }
        func stop(){
            if player?.isPlaying == true {
                player?.stop()
                player?.currentTime = 0
            }
        }
        func pause(){
            if player?.isPlaying == true{
                player?.pause()
            }
        }
        func checkIfPlayerIsPlaying() -> Bool{
            if let isPlaying = player?.isPlaying{
                return isPlaying
            }
            return false
        }
        
        
        func getCurrentTimeAsString() -> String {
            var seconds = 0
            var minutes = 0
            if let time = player?.currentTime {
                seconds = Int(time) % 60
                minutes = (Int(time) / 60) % 60
            }
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }
        func getProgress()->Float{
            var theCurrentTime = 0.0
            var theCurrentDuration = 0.0
            if let currentTime = player?.currentTime, let duration = player?.duration {
                theCurrentTime = currentTime
                theCurrentDuration = duration
            }
            return Float(theCurrentTime / theCurrentDuration)
        }
        func setVolume(_ volume:Float){
            player?.volume = volume
        }
        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
            print("Finish")
           player.stop()
        }
        
}


