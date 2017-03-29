//
//  ViewControllerExtension.swift
//  EcosiaMp3Player
//
//  Created by Vaishakh on 3/29/17.
//  Copyright © 2017 Vaishakh. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: MusicPlayerDelegate {
    // Delegate Function call
    func startNewTrackPlay() {
        print("Start Playback")
        shuffleTrack()
    }
    
    func shuffleTrack() {
        musicPlayer?.resetMusicTrack()
        setTrackBasicInfo()
    }
    
    func setTrackBasicInfo() {
        stopTimer()
        setDisplayInfo()
        if let time = musicPlayer?.player?.duration {
            durationTimeLabel.text = musicPlayer?.convertTimetoStringFormat(time: time)
        }
        playButton.setBackgroundImage(UIImage.init(named: "pause"), for: .normal)
        startTimer()
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updatePlayerViews), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    func updatePlayerViews() {
        
        if let currentTime = musicPlayer?.getCurrentTimeAsString() {
            currentTimeLabel.text = currentTime
        }
        if let progress = musicPlayer?.getProgress() {
            progressSlider.value = progress
        }
    }
    
    
    func setDisplayInfo() {
        let metaInfo = musicPlayer?.getMetaData()
        if let trackTitle = metaInfo?.title {
            trackLabel.text = trackTitle
        }
        if let albumTitle = metaInfo?.albumName {
            albumLabel.text = albumTitle
        }
        if let artist = metaInfo?.artist {
            artistLabel.text = artist
        }
        if let artwork = metaInfo?.artwork {
            artworkImageView.image = artwork
        } else {
            artworkImageView.image = nil
        }
    }
    
}
