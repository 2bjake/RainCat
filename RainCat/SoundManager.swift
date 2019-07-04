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
    var trackPosition = Int.random(in: 0..<SoundManager.tracks.count)
    var isMuted = UserDefaults.standard.bool(forKey: Constants.muteKey) {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: Constants.muteKey)
            UserDefaults.standard.synchronize()

            if isMuted {
                audioPlayer?.stop()
            } else {
                startPlaying()
            }
        }
    }

    //Music: http://www.bensound.com/royalty-free-music
    static private let tracks = [
        "bensound-clearday",
        "bensound-jazzcomedy",
        "bensound-jazzyfrenchy",
        "bensound-littleidea"
    ]

    public func startPlaying() {
        guard !isMuted && audioPlayer?.isPlaying != true else {
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
