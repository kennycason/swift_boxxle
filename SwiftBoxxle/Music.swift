//
//  Music.swift
//  SwiftBoxxle
//
//  Created by Kenny Cason on 10/12/14.
//  Copyright (c) 2014 Kenny Cason. All rights reserved.
//

import AVFoundation

class Music {

    var musicPlayer: AVAudioPlayer!
    var filename: String
    var numberOfLoops: Int
    
    init(filename: String) {
        self.filename = filename
        self.numberOfLoops = 0
        load()
    }
    
    init(filename: String, numberOfLoops: Int) {
        self.filename = filename
        self.numberOfLoops = numberOfLoops
        load()
    }
    
    func load() {
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        if (url == nil) {
            println("Could not find file: \(filename)")
            return
        }
        
        var error: NSError? = nil
        musicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
        if musicPlayer == nil {
            println("Could not create audio player: \(error!)")
            return
        }
        musicPlayer.numberOfLoops = numberOfLoops
        musicPlayer.prepareToPlay()
    }
    
    func play() {
        stop()
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func stop() {
        musicPlayer.stop()
    }

}