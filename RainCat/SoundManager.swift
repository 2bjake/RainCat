//
//  SoundManager.swift
//  RainCat
//
//  Created by Jake Foster on 6/20/19.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let sharedInstance = SoundManager()

    var audioPlayer: AVAudioPlayer?
    var trackPosition = 0

    //Music: http://www.bensound.com/royalty-free-music
    static private let tracks = [
        "bensound-clearday",
        "bensound-jazzcomedy",
        "bensound-jazzyfrenchy",
        "bensound-littleidea"
    ]

    private override init() {
        trackPosition = Int.random(in: 0..<SoundManager.tracks.count)
    }

    public func startPlaying() {
        guard audioPlayer?.isPlaying != true else {
            print("Audio player is already playing!")
            return
        }

        let soundURL = Bundle.main.url(forResource: SoundManager.tracks[trackPosition], withExtension: "mp3")!

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.delegate = self
        } catch {
            print("audio player failed to load")
            startPlaying()
        }

        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        trackPosition = (trackPosition + 1) % SoundManager.tracks.count
        startPlaying()
    }
}
